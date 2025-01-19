; extends
  ; (jsx_element) @jsx.outer
  ; (jsx_element (jsx_opening_element) . (_) @_start (_)? @_end . (jsx_closing_element)) @jsx.inner
  ; (jsx_self_closing_element) @jsx.outer @jsx.inner

; ; JSX Elements
; (jsx_element) @jsx.outer
; (jsx_element 
;   (jsx_opening_element)
;   (_)? @jsx.inner
;   (jsx_closing_element)) 
;
; ; JSX Self-closing Elements
; (jsx_self_closing_element) @jsx.outer
;
; ; JSX Expressions
; (jsx_expression) @jsx.outer
; (jsx_expression (_) @jsx.inner)

; JSX Elements
; (jsx_element) @jsx.outer
; (jsx_element
;   (jsx_opening_element)
;  ((_) @jsx.inner . )* @jsx.inner
;   (jsx_closing_element))
;
; ; JSX Self-closing Elements (only outer)
; (jsx_self_closing_element) @jsx.outer

; JSX Fragments
; (jsx_fragment) @jsx.outer
; (jsx_fragment
;   (_)+ @_inner) @jsx.inner

; JSX Expressions
; (jsx_expression) @jsx.outer
; (jsx_expression (_) @jsx.inner)
