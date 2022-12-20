use "files"
use "../../xml"

actor Main
  let _env: Env
  let _xmlfile: XmlFile

  new create(env: Env) =>
    _env = env
    let path = FilePath(FileAuth(env.root), "test.xml")
    var file: File iso = recover iso File(path) end

    _xmlfile = XmlFile(consume file)
    _xmlfile.parse(this)

  be callback(a: XmlNode, b: String, c: String) =>
    _env.out.print(a.apply())
    _env.out.print("  " + b)
    _env.out.print("    " + c)
