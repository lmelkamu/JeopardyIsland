open! Core
open! Cohttp_async

type t =
  { question : string
  ; answers : string list
  ; answer_idx : int
  ; points : int
  }

(* things we need to get set up: pull from an API ORRRR, we need a sufficient
   question bank with quetsions and plausible answers *)
let get_questions number =
  let response =
    Cohttp_async.Client.get
      (Uri.of_string
         (String.append
            "https://opentdb.com/api.php?amount="
            (Int.to_string number)))
  in
  print_s
    [%message
      (response : (Cohttp.Response.t * Body.t) Async_kernel.Deferred.t)]
;;

get_questions 1
