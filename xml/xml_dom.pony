use "collections"

use @exit[None](a: I32)
use @printf[U8](fmt: Pointer[U8] tag, ...)

class XmlDom
  var dom: XmlDOMNode = XmlDOMNode("".clone(), None)
  var ptr: (XmlDOMNode | None) = None
  var lastkey: (String | None) = None

  fun ref callback(a: XmlNode, b: String, c: String) => None
    match a
    | let t: XmlStartDoc => start_document(t, b, c)
    | let t: XmlError => die()
    | let t: XmlPI => None // Unsupported
    | let t: XmlSTag => start_tag(t, b, c)
    | let t: XmlETag => end_tag(t, b, c)
    | let t: XmlCData=> start_cdata(t, b, c)
    | let t: XmlAttrKey=> start_attrkey(t, b, c)
    | let t: XmlAttrVal=> start_attrval(t, b, c)
    | let t: XmlComment=> None // Unsupported
    | let t: XmlEndDoc => test()
    end

  fun ref start_tag(a: XmlNode, b: String, c: String) =>
    let node: XmlDOMNode = XmlDOMNode(b.clone(), ptr)
    ptr = node

  fun ref end_tag(a: XmlNode, b: String, c: String) =>
    match ptr
    | let t: XmlDOMNode =>
               let parent = t.parent
               match parent
               | let tt: XmlDOMNode =>
                           tt.children.push(t)
                           ptr = tt
               else None end
    else None end

  fun ref start_cdata(a: XmlNode, b: String, c: String) =>
    match ptr
    | let t: XmlDOMNode => t.content = b
    else
      die()
    end

  fun ref start_attrval(a: XmlNode, b: String, c: String) =>
    match lastkey
    | let t: String =>
      match ptr
      | let tt: XmlDOMNode => tt.attributes.insert(t, b)
      else
        None
      end
    else
      die()
    end

  fun ref start_attrkey(a: XmlNode, b: String, c: String) =>
    lastkey = b

  fun ref start_document(a: XmlNode, b: String, c: String) =>
    let node: XmlDOMNode = XmlDOMNode("".clone(), None)
    ptr = node
    dom = node

  fun die() =>
    @printf("I died".cstring())
    @exit(1)


  fun test() => None
    dom.print()
