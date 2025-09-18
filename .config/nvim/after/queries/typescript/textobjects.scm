; extends
 
(type_parameter) @type.inner
(type_parameter
  name: (type_identifier)
  constraint: (_)?
  value: (_)?) @type.inner

(type_parameter
  (type_identifier)
  (_)*) @type.inner

(type_parameter) @type.outer

(type_parameters
  .
  "<"
  _+ @type.inner
  ">")
(type_parameters) @type.outer


(type_annotation
  ":" @_colon
  (_) @type.inner) @type.outer

(union_type) @type.inner  
(union_type) @type.outer

(intersection_type) @type.inner
(intersection_type) @type.outer

(type_arguments) @type.outer
(type_arguments
  .
  "<"
  _+ @type.inner
  ">")

(generic_type) @type.outer
(generic_type
  name: (type_identifier) @_name
  type_arguments: (type_arguments) @type.inner)

