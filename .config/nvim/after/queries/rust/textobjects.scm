
; extends
;
; Function return types
(function_item
  return_type: (_) @type.inner) @type.outer

; Type annotations in parameters
(parameter
  type: (_) @type.inner) @type.outer

; Type annotations in let declarations
(let_declaration
  type: (_) @type.inner) @type.outer

; Type identifiers
(type_identifier) @type.inner

; Generic types
(generic_type
  type: (type_identifier) @type.name
  type_arguments: (type_arguments
    (_) @type.arguments)) @type.outer

; Struct declarations
(struct_item
  name: (type_identifier) @type.name) @type.outer

; Enum declarations
(enum_item
  name: (type_identifier) @type.name) @type.outer

; Field declarations in structs
(field_declaration
  type: (_) @type.inner) @type.outer

; Type annotations in enum variants
(enum_variant
  body: (ordered_field_declaration_list
    type: (_) @type.inner)) @type.outer
