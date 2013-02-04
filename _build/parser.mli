type token =
  | EOF
  | INT of (Range.t * int32)
  | X of (Range.t)
  | MINUS of (Range.t)
  | PLUS of (Range.t)
  | TIMES of (Range.t)
  | EQ of (Range.t)
  | NEQ of (Range.t)
  | LT of (Range.t)
  | LTE of (Range.t)
  | GT of (Range.t)
  | GTE of (Range.t)
  | LOGNOT of (Range.t)
  | NOT of (Range.t)
  | AND of (Range.t)
  | OR of (Range.t)
  | SHL of (Range.t)
  | SHR of (Range.t)
  | SAR of (Range.t)
  | LPAREN of (Range.t)
  | RPAREN of (Range.t)

val toplevel :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.exp
