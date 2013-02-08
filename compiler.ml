(* compiler.ml *)
(* A compiler for simple arithmetic expressions. *)

(******************************************************************************)

open Printf
open Platform
open List
open Cunit
open X86   (* Note that Ast has similarly named constructors that must be 
              disambiguated.  For example: Ast.Shl vs. X86.Shl *)

(* Parse an AST from a preexisting lexbuf. 
 * The filename is used to generate error messages.
*)
let parse (filename : string) (buf : Lexing.lexbuf) : Ast.exp =
  try
    Lexer.reset_lexbuf filename buf;
    Parser.toplevel Lexer.token buf
  with Parsing.Parse_error ->
    failwith (sprintf "Parse error at %s."
        (Range.string_of_range (Lexer.lex_range buf)))


(* Builds a globally-visible X86 instruction block that acts like the C fuction:

   int program(int X) { return <expression>; }

   Follows cdecl calling conventions and platform-specific name mangling policy. *)
let compile_exp (ast:Ast.exp) : cunit =
  let cmp_op a c i = [And (eax, Imm 1l); Setb (eax, c); Cmp (eax, a)] @ i in
  let bop b insns =
    Push eax :: match b with
      | Ast.Plus  -> Add (eax, ecx) :: insns
      | Ast.Times -> Imul (Eax, ecx) :: insns
      | Ast.Minus -> Sub (eax, ecx) :: insns
      | Ast.And   -> And (eax, ecx) :: insns
      | Ast.Or    -> Or (eax, ecx) :: insns
      | Ast.Shl   -> Shl (eax, ecx) :: insns
      | Ast.Sar   -> Sar (eax, ecx) :: insns
      | Ast.Shr   -> Shr (eax, ecx) :: insns
      | Ast.Eq    -> cmp_op ecx Eq insns
      | Ast.Neq   -> cmp_op ecx NotEq insns
      | Ast.Lt    -> cmp_op ecx Slt insns
      | Ast.Lte   -> cmp_op ecx Sle insns
      | Ast.Gt    -> cmp_op ecx Sgt insns
      | Ast.Gte   -> cmp_op ecx Sge insns in
  let uop o insns =
    Push eax :: match o with
      | Ast.Neg    -> Neg eax :: insns
      | Ast.Not    -> Not eax :: insns
      | Ast.Lognot -> cmp_op (Imm 0l) Eq insns in
  let rec conv e is =
    match e with
      | Ast.Binop (f, a, b) -> bop f ([Pop ecx; Pop eax] @ (conv a (conv b is)))
      | Ast.Unop (f, a)     -> uop f (Pop eax :: conv a is)
      | Ast.Arg             -> Push edx :: is
      | Ast.Cint i          -> Push (Imm i) :: is in
  [Code {global = true; label = mk_lbl_named (decorate_cdecl "program"); 
         insns = Mov (edx, stack_offset 4l) :: rev ([Ret; Pop eax] @ conv ast [])}]