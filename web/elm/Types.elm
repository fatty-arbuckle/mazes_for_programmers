module Types exposing (..)

import Keyboard.Extra
import Sprite
import Map
import Time exposing (Time)


type alias Model =
  { sprite : Sprite.Model
  , map : Map.Model
  , keyboard : Keyboard.Extra.Model
  }

type Msg
    = Tick Time
    | KeyPress Keyboard.Extra.Msg
    | Nothing
