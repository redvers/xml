type XmlNode is (
  XmlError
  | XmlPI
  | XmlSTag | XmlETag
  | XmlCData
  | XmlAttrKey | XmlAttrVal
  | XmlComment
  | XmlStartDoc | XmlEndDoc
)

primitive XmlPI fun apply(): String => "PI"
primitive XmlSTag fun apply(): String => "STag"
primitive XmlETag fun apply(): String => "ETag"
primitive XmlCData fun apply(): String => "CData"
primitive XmlAttrKey fun apply(): String => "AttrKey"
primitive XmlAttrVal fun apply(): String => "AttrVal"
primitive XmlComment fun apply(): String => "Comment"
primitive XmlStartDoc fun apply(): String => "StartDocument"
primitive XmlEndDoc fun apply(): String => "EndDocument"
