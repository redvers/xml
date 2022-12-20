use "files"

actor XmlFile
  let _file: File
  var _xml: (Xml | None) = None

  new create(file: File iso) =>
    _file = consume file

  be parse(client: XmlSAXReceiver tag) =>
    _xml = Xml.create(client~callback())
    _process_chunk()

  be _process_chunk() =>
    if not (_file.errno() is FileOK) then
      _file.dispose()
      return
    end

    let data: String = _file.read_string(32)
    match _xml
    | let xml: Xml => xml.parse(data)
    _process_chunk()
    else
      None
    end

interface XmlSAXReceiver
  be callback(a: XmlNode, b: String, c: String)
