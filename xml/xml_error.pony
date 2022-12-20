type XmlError is (
  XmlNone
  | XmlTagMismatch
  | XmlEntityError
)

primitive XmlNone fun apply(): String => "(none)"
primitive XmlTagMismatch fun apply(): String => "FATAL_TagMismatch"
primitive XmlEntityError fun apply(): String => "FATAL_EntityError"
