module App exposing (..)

import Html.App

import View
import State

main : Program Never
main =
  Html.App.program
    { init = State.init
    , view = View.view
    , update = State.update
    , subscriptions = State.subscriptions
    }
