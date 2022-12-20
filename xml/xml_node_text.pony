class XmlNodeText
  new box create() =>
    None

  fun box apply(node: XmlNode): String =>
    match node
    | XmlPI => "PI"
    | XmlSTag => "STag"
    | XmlETag => "ETag"
    | XmlCData => "CData"
    | XmlAttrKey => "AttrKey"
    | XmlAttrVal => "AttrVal"
    | XmlComment => "Comment"

    | XmlStartDoc => "@start document"
    | XmlEndDoc => "@end document"

    | XmlTagMismatch => "(tag mismatch)"
    | XmlEntityError => "(entity error)"

    | XmlNone => "(none)"
    end

