use "files"
use "../../xml"

use @printf[U8](fmt: Pointer[U8] tag, ...)

actor Main
  let _env: Env
  let _xml: Xml
  let _dom: XmlDom = XmlDom
  let _file: File

  new create(env: Env) =>
    _env = env
    let path = FilePath(FileAuth(env.root), "libxml2.xml")
    _file = File(path)

    _xml = Xml.create(this~callback())
    process_chunk()

  fun got_dom() =>
    _dom.dom.print()
    _env.out.print("Start Phase I")


  be process_chunk() =>
    if not (_file.errno() is FileOK) then
      _file.dispose()
      return
    end

    let data: String = _file.read_string(32)
    _xml.parse(data)
    process_chunk()


  be callback(a: XmlNode, b: String, c: String) => None
    match a
    | let x: XmlEndDoc => got_dom()
    else
      _dom.callback(a, b, c)
    end


