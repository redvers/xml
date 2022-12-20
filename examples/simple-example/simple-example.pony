// in your code this `use` statement would be:
// use "postgres"
use "files"
use "../../xml"

actor Main
  let _file: File
  let _xml: Xml
  let _env: Env

  new create(env: Env) =>
    _env = env
    let path = FilePath(FileAuth(env.root), "test.xml")
    _file = File(path)

    _xml = Xml.create(this~callback())
    
    process_chunk()


  be process_chunk() =>
    if not (_file.errno() is FileOK) then
      _file.dispose()
      return
    end

    let data: String = _file.read_string(32)
    _xml.parse(data)
    process_chunk()


  be callback(a: XmlNode, b: String, c: String) => None
    _env.out.print(a.apply())
    _env.out.print("  " + b)
    _env.out.print("    " + c)
    


