; extends

(jsx_attribute
  (property_identifier) @assignment.lhs
  (_) @assignment.rhs @assignment.inner) @assignment.outer

(jsx_element) @jsx_element.outer

(jsx_element
  open_tag: (jsx_opening_element)
  .
  (_)* @jsx_element.inner
  .
  close_tag: (jsx_closing_element)
  )

(jsx_self_closing_element) @jsx_element.outer

(jsx_self_closing_element
  name: (identifier)
  .
  (_)* @jsx_element.inner
  .
  )
