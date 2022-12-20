class XmlToken
  var text: String
  var proc: XmlTokenProc
  var pos: ISize

  new create(text': String, proc': XmlTokenProc) =>
    text = text'
    proc = proc'
    pos = 0

  fun box size(): ISize =>
    text.size().isize()

  fun ref find(source: String box): Bool val =>
    try
      pos = source.find(text)?
      true
    else
      false
    end



