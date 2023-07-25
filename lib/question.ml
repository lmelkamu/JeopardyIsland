open! Core
open! Cohttp_async


let global_questions :


type t =
  { question : string
  ; answers : string list
  ; answer_idx : int
  ; points : int
  }


  (* things we need to get set up: pull from an API ORRRR, we need a sufficient question bank with quetsions and plausible answers *)
