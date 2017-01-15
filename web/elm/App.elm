module App exposing (..)

import Html

import View
import State
import Types

main : Program Never Types.Model Types.Msg
main =
  Html.program
    { init = State.init
    , view = View.view
    , update = State.update
    , subscriptions = State.subscriptions
    }
