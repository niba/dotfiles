; extends
;
(type_parameter) @type.inner
(type_parameters) @type.outer

(type_annotation
  ":" @_colon
  (_) @type.inner) @type.outer

(type_arguments
  (_) @_start
  .
  (_)* @_end
  (#make-range! "type.inner" @_start @_end)) @type.outer

(generic_type
  name: (type_identifier) @_name
  type_arguments: (type_arguments) @_args
  (#make-range! "type.inner" @_name @_args)) @type.outer

(type_parameter
  name: (type_identifier)
  constraint: (_)?
  value: (_)?) @type.inner

(type_parameter
  (type_identifier)
  (_)*) @type.inner
