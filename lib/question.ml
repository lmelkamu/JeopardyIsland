open! Core
open! Async
open! Cohttp_async

(* type t = { question : string ; answers : string list ; answer_idx : int ;
   points : int } *)

(* things we need to get set up: pull from an API ORRRR, we need a sufficient
   question bank with quetsions and plausible answers *)
let get_questions number =
  let%bind _, body =
    Cohttp_async.Client.get
      (Uri.of_string
         (String.append
            "https://opentdb.com/api.php?amount="
            (Int.to_string number)))
  in
  Body.to_string body
;;

let question_command =
  let open Command.Let_syntax in
  Command.basic
    ~summary:
      "parse a file listing interstates and generate a graph visualizing \
       the highway network"
    [%map_open
      fun () ->
        let%map response = get_questions 1 in
        print_s [%message (response : string)]]
;;
