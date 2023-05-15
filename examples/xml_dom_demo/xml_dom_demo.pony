use "files"
use "../../xml"

actor Main
  let _env: Env
  let _xmlfile: XmlFile

  new create(env: Env) =>
    _env = env
    let path = FilePath(FileAuth(env.root), "GLib-2.0.gir")
    var file: File iso = recover iso File(path) end

    _xmlfile = XmlFile(consume file)
    let xmldom: XmlDom = XmlDom
    _xmlfile.parse(xmldom)

