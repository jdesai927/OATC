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
  | X   { Arg }
