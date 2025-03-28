; extends

(expression_statement
  (assignment_expression
    left: (_) @assignment.lhs
    right: (_) @assignment.inner @assignment.rhs)) @assignment.outer

