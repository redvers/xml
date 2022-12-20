use "collections"

//type XmlNodeNotify is {(XmlNode, String)} val
type XmlNodeNotify is {(XmlNode, String, String)} val


type XmlTokenProc is {ref ()}

actor Xml
    let _notify: XmlNodeNotify

    let _entity: Map[String, String] = Map[String, String].create()
    let _token: List[XmlToken] = List[XmlToken].create()
    let _tsave: List[XmlToken] = List[XmlToken].create()

    var _reset: Bool = true

    let _stag: List[String] = List[String].create()
    var _attrkey: String = ""

    var _nextnode: XmlNode = XmlNone
    var _lastnode: XmlNode = XmlNone
    var _content: String = ""

    var _head: String = ""

    var _src: String = ""

    new create(notify': XmlNodeNotify) =>
        _notify = notify'

        _entity("amp") = "&"
        _entity("lt") = "<"
        _entity("gt") = ">"
        _entity("apos") = "'"
        _entity("quot") = "\""

        state_init()

    be reset() =>
        state_init()
        _reset = true
        _stag.clear()
        _attrkey = ""
        _nextnode = XmlNone
        _lastnode = XmlNone
        _content = ""
        _head = ""
        _src = ""

    fun box path(): String =>
        String.from_utf32('/').join(_stag.values()) + if _attrkey.size() > 0 then "#" + _attrkey else "" end

    fun ref notify(node: XmlNode, content: String) =>
        if _reset then
            _notify(XmlStartDoc, "", "")
            _reset = false
        end
        _notify(node, content, path())
        if (node is XmlETag) and (_stag.size() == 0) then
            _notify(XmlEndDoc, "", "")
        end

    fun ref append_notify() =>
        _content = _content + _head
        let node = match _lastnode
            | XmlNone => _nextnode
        else
            _lastnode
        end
        if node is XmlCData then
            let ct = _content.clone()
//            ct.strip(" \t\n\r")
            ct.lstrip(" \t\n\r")
            _content = consume ct
        end
        if _content.size() > 0 then
            if not (node is XmlNone) then
                notify(node, _content)
            end

            if _lastnode is XmlSTag then
                _stag.push(_content)
            elseif node is XmlAttrKey then
                _attrkey = _content
            elseif node is XmlAttrVal then
                _attrkey = ""
            end

            _content = ""
        end

    fun ref push_token(text: String, proc: XmlTokenProc) =>
        _token.push(XmlToken.create(text, proc))

    fun ref token_whitespace() =>
        push_token(" ", this~state_whitespace())
        push_token("\t", this~state_whitespace())
        push_token("\n", this~state_whitespace())
        push_token("\r", this~state_whitespace())

    fun ref token_tag_open_start() =>
        push_token("<", this~state_tag_open_start())

    fun ref token_tag_open_end() =>
        push_token("</", this~state_tag_open_end())

    fun ref token_tag_close_long(stag: Bool) =>
        push_token(">", this~state_tag_close_long(stag))

    fun ref token_tag_close_short() =>
        push_token("/>", this~state_tag_close_short())

    fun ref token_cdata_open() =>
        push_token("<![CDATA[", this~state_cdata_open())

    fun ref token_cdata_close() =>
        push_token("]]>", this~state_cdata_close())

    fun ref token_comment_open() =>
        push_token("<!--", this~state_comment_open())

    fun ref token_comment_close() =>
        push_token("-->", this~state_comment_close())

    fun ref token_pi_open() =>
        push_token("<?", this~state_pi_open())

    fun ref token_pi_close() =>
        push_token("?>", this~state_pi_close())

    fun ref token_entity_open() =>
        push_token("&", this~state_entity_open())

    fun ref token_entity_close() =>
        push_token(";", this~state_entity_close())

    fun ref token_equal() =>
        push_token("=", this~state_equal())

    fun ref token_quot(open: Bool) =>
        push_token("\"", this~state_quot(open))

    fun ref token_apot(open: Bool) =>
        push_token("'", this~state_apot(open))

    fun ref token_all_open() =>
        token_cdata_open()
        token_comment_open()
        token_pi_open()
        token_tag_open_end()
        token_tag_open_start()
        token_entity_open()

    fun ref state_init() =>
        _tsave.clear()
        _token.clear()
        token_pi_open()
        token_comment_open()
        token_tag_open_start()

    fun ref state_whitespace() =>
        append_notify()
        _lastnode = XmlNone

    fun ref state_tag_open_start() =>
        append_notify()
        _lastnode = XmlSTag
        _nextnode = XmlAttrKey

        _token.clear()
        token_equal()
        token_whitespace()
        token_tag_close_short()
        token_tag_close_long(true)

    fun ref state_tag_open_end() =>
        append_notify()
        _lastnode = XmlETag
        _nextnode = XmlNone

        _token.clear()
        token_tag_close_long(false)

    fun ref state_tag_close_long(stag: Bool) =>
        if stag then
            append_notify()
            _lastnode = XmlNone
            _nextnode = XmlCData
        else
            if not (_lastnode is XmlETag) then
                None // uh oh?
            end
            _lastnode = XmlNone
            _nextnode = XmlCData

            let endtag = _head
            let starttag = try _stag.pop()? else "" end
            if starttag != endtag then
                notify(XmlTagMismatch, starttag + "/" + endtag)
            end

            notify(XmlETag, endtag)
        end

        _token.clear()
        token_all_open()

    fun ref state_tag_close_short() =>
        append_notify()
        _lastnode = XmlNone
        _nextnode = XmlCData

        notify(XmlETag, try _stag.pop()? else "" end)

        _token.clear()
        token_all_open()

    fun ref state_cdata_open() =>
        _content = _content + _head

        _token.clear()
        token_cdata_close()

    fun ref state_cdata_close() =>
        _content = _content + _head

        _token.clear()
        token_all_open()

    fun ref state_comment_open() =>
        _token.clear()
        token_comment_close()

    fun ref state_comment_close() =>
        notify(XmlComment, _head)

        _token.clear()
        token_all_open()

    fun ref state_pi_open() =>
        _token.clear()
        token_pi_close()

    fun ref state_pi_close() =>
        // todo handle XMLDecl
        notify(XmlPI, _head)

        _token.clear()
        token_all_open()

    fun ref state_entity_open() =>
        _content = _content + _head

        _tsave.clear()
        _tsave.append_list(_token)
        token_entity_close()

    fun ref state_entity_close() =>
        _content = _content + parse_entity(_head)

        _token.clear()
        _token.append_list(_tsave)

    fun ref state_equal() =>
        append_notify()
        _lastnode = XmlNone
        _nextnode = XmlAttrVal

        _token.clear()
        token_whitespace()
        token_quot(true)
        token_apot(true)

    fun ref state_quot(open: Bool) =>
        _token.clear()
        if open then
            token_entity_open()
            token_quot(false)
        else
            append_notify()
            _lastnode = XmlNone
            _nextnode = XmlAttrKey

            token_equal()
            token_whitespace()
            token_tag_close_short()
            token_tag_close_long(true)
        end

    fun ref state_apot(open: Bool) =>
        _token.clear()
        if open then
            token_entity_open()
            token_apot(false)
        else
            append_notify()
            _lastnode = XmlNone
            _nextnode = XmlAttrKey

            token_equal()
            token_whitespace()
            token_tag_close_short()
            token_tag_close_long(true)
        end

    fun ref parse_entity(source: String): String =>
        try
            if source.substring(0, 1) != "#" then
                return _entity(source)?
            end
            var from: ISize = 1
            var base: U8 = 10
            if source.substring(1, 2) == "x" then
                from = 2
                base = 16
            end
            return recover String.from_utf32(source.substring(from).u32(base)?) end
        end
        notify(XmlEntityError, source)
        ""

    be parse(source: String) =>
        _src = _src + source
        var nth: USize = 0
        while true do
            let find_to =
            try
                _src.find(">", 0, nth)?
            else
                break
            end

            var found: XmlToken =
            try
                var token: (XmlToken | None) = None

                var to: ISize = find_to
                let tv = _token.values()
                while tv.has_next() do
                    try
                        let t = tv.next()?
                        if t.find(_src.substring(0, to + t.size())) then
                            token = t
                            if t.pos == 0 then
                                break
                            end
                            to = t.pos - 1
                        end
                    end
                end

                token as XmlToken
            else
//                break
                nth = nth + 1
                continue
            end

            _head = _src.substring(0, found.pos)
            found.proc()

            let cut = found.pos + found.size()
            _src = _src.cut(0, cut)
        end

