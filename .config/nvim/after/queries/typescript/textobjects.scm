; extends
; (type_annotation 
;   ":" @colon
;   (_) @type.inner) @type.outer

(type_annotation
  [(type_identifier) (predefined_type)] @type.inner) @type.outer

(type_arguments
  [(type_identifier) (predefined_type)] @type.inner) @type.outer

(type_parameter
  name: (type_identifier) @type.inner) @type.outer

(type_annotation) @type.outer
(type_parameter) @type.outer

(type_arguments) @type.outer
(type_parameters) @type.outer
