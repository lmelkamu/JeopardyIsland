open! Core
open! Async

<<<<<<< HEAD
let command =
  Command.async
    ~summary:
      "given a website that generates questions, GET a question and the 4 \
       associated answer choices"
    (let%map_open.Command () = return () in
     fun () -> return ())
;;
=======
(* let command = Command.async ~summary: "given an IMDB page for an actor,
   print out a list of their main \ credits" (let%map_open.Command () =
   return () in fun () -> return ()) *)
>>>>>>> 36d27da9aa4e5de7bfa760dd9eaa9cba31c722dc

(* [%map_open let how_to_fetch, resource = File_fetcher.param in fun () ->
   let contents = File_fetcher.fetch_exn how_to_fetch ~resource in List.iter
   (get_credits contents) ~f:print_endline] *)

let command =
  Command.group
    ~summary:"A tool for playing the wikipedia game, and other utilities"
    [ "game", Jeopardy_island.Game.game_command
    ; "question", Jeopardy_island.Question.question_command
    ]
;;

let _ = Cohttp_async.Client.get
let () = Command_unix.run Jeopardy_island.Game.game_command
