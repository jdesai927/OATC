%{
open Ast;;
%}

/* Declare your tokens here. */
%token EOF
%token <Range.t * int32> INT
%token <Range.t> X        /* X   */
%token <Range.t> MINUS    /* -   */
%token <Range.t> PLUS     /* +   */
%token <Range.t> TIMES    /* *   */
%token <Range.t> EQ       /* ==  */
%token <Range.t> NEQ      /* !=  */
%token <Range.t> LT       /* <   */
%token <Range.t> LTE      /* <=  */
%token <Range.t> GT       /* >   */
%token <Range.t> GTE      /* >=  */
%token <Range.t> LOGNOT   /* !   */
%token <Range.t> NOT      /* ~   */
%token <Range.t> AND      /* &   */
%token <Range.t> OR       /* |   */
%token <Range.t> SHL      /* <<  */
%token <Range.t> SHR      /* >>> */
%token <Range.t> SAR      /* >>  */
%token <Range.t> LPAREN   /* (   */
%token <Range.t> RPAREN   /* )   */


/* ---------------------------------------------------------------------- */
%start toplevel
%type <Ast.exp> toplevel
%type <Ast.exp> exp
%%

toplevel:
  | exp EOF { $1 }

/* Declare your productions here, starting with 'exp'. */

exp:
  | or { $1 }

or:
  | or OR and { Binop Or $1 $2 }
  | and { $1 }

and:
  | and AND cmp1 { Binop And $1 $2 }
  | cmp1 { $1 }

cmp1:
  | cmp1 EQ cmp2 { Binop Eq $1 $2 }
  | cmp1 NEQ cmp2 { Binop Neq $1 $2 }
  | cmp2 { $1 }

cmp2:
  | cmp2 LT shift { Binop Lt $1 $2 }
  | cmp2 LTE shift { Binop Lte $1 $2 }
  | cmp2 GT shift { Binop Gt $1 $2 }
  | cmp2 GTE shift { Binop Gte $1 $2 }
  | shift { $1 }

shift:
  | shift SHL arith { Binop Shl $1 $2 }
  | shift SHR arith { Binop Shr $1 $2 }
  | shift SAR arith { Binop Sar $1 $2 }
  | arith { $1 }

arith:
  | arith PLUS geom { Binop Plus $1 $2 }
  | arith MINUS geom { Binop Minus $1 $2 }
  | geom { $1 }

geom:
  | geom TIMES un { Binop Times $1 $2 }
  | un { $1 }

un:
  | LOGNOT un { Unop (Lognot, $1) }
  | NOT un { Unop (Not, $1) }
  | MINUS un { Unop (Neg, $1) }
  | paren { $1 }

paren:
  | LPAREN exp RPAREN { $1 }
  | const { $1 }

const:
  | INT { Cint $1 }
  | X { Arg }