module Types exposing (..)

import Keyboard.Extra
import Sprite
import Map
import Time exposing (Time)
import Http


type alias Model =
  { sprite : Sprite.Model
  , map : Map.Model
  , keyboard : Keyboard.Extra.Model
  , generators : List String
  , errors : List String
  , maze : Map.Maze
  }

type Msg
    = Tick Time
    | KeyPress Keyboard.Extra.Msg
    | Nothing
    | LoadGenerators
    | ReceivedGenerators (Result Http.Error (List String))
    | GenerateMaze String
    | ReceivedMaze (Result Http.Error Map.Maze)
