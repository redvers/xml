use "collections"

class XmlDOMNode
  let name: String val
  let attributes: Map[String, String] = Map[String, String]
  let children: Array[XmlDOMNode] = []
  let parent: (XmlDOMNode | None)
  var content: String = ""
  var path: String val = ""

  new create(name': String iso, parent': (XmlDOMNode | None)) =>
    name = consume name'
    parent = parent'

  fun print(depth: USize = 0) =>
    @printf("\n%sPATH: %s\n".cstring(), " ".mul(depth).cstring(), path.cstring())
    @printf("\n%sNode: %s\n".cstring(), " ".mul(depth).cstring(), name.cstring())
    if (content != "") then
      @printf("%sContent: %s\n".cstring(), " ".mul(depth).cstring(), content.cstring())
    end

    if (attributes.size() > 0) then
      for (k,v) in attributes.pairs() do
        @printf("%sKey: %s --> %s\n".cstring(), " ".mul(depth).cstring(), k.cstring(), v.cstring())
      end
    end
    if (children.size() > 0) then
      @printf("%sNumber of children: %d\n".cstring(), " ".mul(depth).cstring(), children.size())

      for f in children.values() do
        f.print(depth + 2)
      end
    end

