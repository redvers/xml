type XmlError is (
  XmlNone
  | XmlTagMismatch
  | XmlEntityError
)

primitive XmlNone fun apply(): String => "(none)"
primitive XmlTagMismatch fun apply(): String => "TagMismatch"
primitive XmlEntityError fun apply(): String => "EntityError"
