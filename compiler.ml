(* compiler.ml *)
(* A compiler for simple arithmetic expressions. *)

(******************************************************************************)

open Printf
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
let compile_exp (ast:Ast.exp) : Cunit.cunit =
  let block_name = Platform.decorate_cdecl "program" in
  let get_bop b insns =
    let st b = Push eax :: b :: insns in
    begin match b with
      | Ast.Plus  -> st (Add (eax, ecx))
      | Ast.Times -> st (Imul (Eax, ecx))
      | Ast.Minus -> st (Sub (eax, ecx))
      | Ast.And   -> st (And (eax, ecx))
      | Ast.Or    -> st (Or (eax, ecx))
      | Ast.Shl   -> st (Shl (eax, ecx))
      | Ast.Sar   -> st (Sar (eax, ecx))
      | Ast.Shr   -> st (Shr (eax, ecx))
      | _         -> failwith "gtfo"
    end in
  let get_un o insns =
    let un u = Push eax :: u :: insns in
    begin match o with
      | Ast.Neg    -> un (Neg eax)
      | Ast.Lognot -> failwith "fuck lognot"
      | Ast.Not    -> un (Not eax)
    end in
  let rec emit_exp e insns =
    begin match e with
      | Ast.Binop (bop, e1, e2) ->
        get_bop bop (Pop ecx :: Pop eax :: (emit_exp e1 (emit_exp e2 insns)))
      | Ast.Unop (op, ex)      -> get_un op (Pop eax :: emit_exp ex insns)
      | Ast.Arg             -> Push edx :: insns
      | Ast.Cint i          -> Push (Imm i) :: insns
    end in
  let insns = Mov (edx, stack_offset 4l) :: 
              List.rev (Ret :: Pop eax :: emit_exp ast []) in
  [Cunit.Code { global = true; label = mk_lbl_named block_name; insns = insns; }]