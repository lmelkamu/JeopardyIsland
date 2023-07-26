open! Core
open! Async

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

let () = Command_unix.run command
