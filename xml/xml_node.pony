type XmlNode is (
  XmlError
  | XmlPI
  | XmlSTag | XmlETag
  | XmlCData
  | XmlAttrKey | XmlAttrVal
  | XmlComment
  | XmlStartDoc | XmlEndDoc
)

primitive XmlPI
primitive XmlSTag
primitive XmlETag
primitive XmlCData
primitive XmlAttrKey
primitive XmlAttrVal
primitive XmlComment
primitive XmlStartDoc
primitive XmlEndDoc
