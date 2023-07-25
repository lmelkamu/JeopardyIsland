open! Core
open! Async

let command =
  Command.async
    ~summary:
      "given an IMDB page for an actor, print out a list of their main \
       credits"
    (let%map_open.Command () = return () in
     fun () -> return ())
;;

(* [%map_open let how_to_fetch, resource = File_fetcher.param in fun () ->
   let contents = File_fetcher.fetch_exn how_to_fetch ~resource in List.iter
   (get_credits contents) ~f:print_endline] *)

let _ = Cohttp_async.Client.get
let () = Command_unix.run command
