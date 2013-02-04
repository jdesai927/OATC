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
%type <Ast.exp> or
%type <Ast.exp> and
%type <Ast.exp> shift
%type <Ast.exp> cmp1
%type <Ast.exp> cmp2
%type <Ast.exp> arith
%type <Ast.exp> geom
%type <Ast.exp> un
%type <Ast.exp> paren
%type <Ast.exp> const
%%

toplevel:
  | exp EOF { $1 }

/* Declare your productions here, starting with 'exp'. */

exp:
  | or { $1 }

or:
  | or OR and { Binop (Or, $1, $3) }
  | and { $1 }

and:
  | and AND cmp1 { Binop (And, $1, $3) }
  | cmp1 { $1 }

cmp1:
  | cmp1 EQ cmp2 { Binop (Eq, $1, $3) }
  | cmp1 NEQ cmp2 { Binop (Neq, $1, $3) }
  | cmp2 { $1 }

cmp2:
  | cmp2 LT shift { Binop (Lt, $1, $3) }
  | cmp2 LTE shift { Binop (Lte, $1, $3) }
  | cmp2 GT shift { Binop (Gt, $1, $3) }
  | cmp2 GTE shift { Binop (Gte, $1, $3) }
  | shift { $1 }

shift:
  | shift SHL arith { Binop (Shl, $1, $3) }
  | shift SHR arith { Binop (Shr, $1, $3) }
  | shift SAR arith { Binop (Sar, $1, $3) }
  | arith { $1 }

arith:
  | arith PLUS geom { Binop (Plus, $1, $3) }
  | arith MINUS geom { Binop (Minus, $1, $3) }
  | geom { $1 }

geom:
  | geom TIMES un { Binop (Times, $1, $3) }
  | un { $1 }

un:
  | LOGNOT un { Unop (Lognot, $2) }
  | NOT un { Unop (Not, $2) }
  | MINUS un { Unop (Neg, $2) }
  | paren { $1 }

paren:
  | LPAREN exp RPAREN { $2 }
  | const { $1 }

const:
  | INT { Cint (snd $1) }
  | X { Arg }