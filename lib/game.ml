open! Core

module Game_state = struct
  type t =
    | Game_continues of Island.t
    | Game_over of Player.t
end

module Level = struct
  type t =
    | Easy
    | Medium
    | Hard
end

module G = Graph.Imperative.Graph.Concrete (String)

module Dot = Graph.Graphviz.Dot (struct
  include G

  let edge_attributes _ = [ `Dir `Forward ]
  let default_edge_attributes _ = []
  let get_subgraph _ = None
  let vertex_attributes v = [ `Shape `Box; `Label v; `Fillcolor 1000 ]
  let vertex_name v = v
  let default_vertex_attributes _ = []
  let graph_attributes _ = []
end)

type t =
  { player_one : Player.t
  ; player_two : Player.t
  ; game_state : Game_state.t
  ; difficulty : Level.t
  }

let rec create_graph ~graph ~nodes ~(distance : float) =
  List.iter nodes ~f:(fun (node_1, x1, y1) ->
    List.iter nodes ~f:(fun (node_2, x2, y2) ->
      if String.equal node_1 node_2
      then ()
      else (
        let pythagoreum =
          Float.sqrt
            (Int.pow (x2 - x1) 2 + Int.pow (y2 - y1) 2 |> Float.of_int)
        in
        if Float.( < ) pythagoreum distance
        then G.add_edge graph node_1 node_2)));
  G.iter_vertex
    (fun vertex ->
      if G.out_degree graph vertex = 0
      then create_graph ~graph ~nodes ~distance:(distance +. 0.5))
    graph
;;

let create game =
  let graph = G.create () in
  let size, bound =
    match game.difficulty with
    | Level.Easy -> 10, 9
    | Level.Medium -> 15, 10
    | Level.Hard -> 20, 11
  in
  let solar_system =
    [ "Neptune"
    ; "Pluto"
    ; "Uranus"
    ; "Mercury"
    ; "Venus"
    ; "Titan"
    ; "Mars"
    ; "Jupiter"
    ; "Sun"
    ; "Moon"
    ; "Ganymede"
    ; "Callisto"
    ; "Io"
    ; "Europa"
    ; "Triton"
    ; "Eris"
    ; "Titania"
    ; "Rhea"
    ; "Iapetus"
    ; "Oberon"
    ]
  in
  List.iter (List.range 0 size) ~f:(fun idx ->
    let planet = List.nth_exn solar_system idx in
    G.add_vertex graph planet);
  let nodes =
    List.map solar_system ~f:(fun planet ->
      let x =
        Int63.random (Int63.of_int bound) |> Int63.to_int |> Option.value_exn
      in
      let y =
        Int63.random (Int63.of_int bound) |> Int63.to_int |> Option.value_exn
      in
      planet, x, y)
  in
  create_graph ~graph ~nodes ~distance:1.0;
  Dot.output_graph (Out_channel.create "/map.dot") graph
;;

let%expect_test "graph" =
  let island =
    { Island.name = "hawaii"
    ; position = 0, 0
    ; question = "hello"
    ; color = 0, 0, 0
    }
  in
  let player_one =
    { Player.name = "Bob"
    ; points = 0
    ; curr_island = island
    ; upgrades = Player.Upgrade.Double_points
    }
  in
  let player_two =
    { Player.name = "Sarah"
    ; points = 0
    ; curr_island = island
    ; upgrades = Player.Upgrade.Double_points
    }
  in
  let game =
    { player_one
    ; player_two
    ; game_state = Game_state.Game_continues island
    ; difficulty = Level.Easy
    }
  in
  create game;
  let connected = true in
  G.iter_vertex (fun vertex ->
    if G.out_degree graph vertex = 0 then connected = false);
  print_s [%message (connected : bool)];
  [%expect true]
;;
