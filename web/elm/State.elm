module State exposing (init, update, subscriptions)

import Types exposing (..)

init : ( Model, Cmd Msg)
init =
  ( { test = "foobar" }, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    _ ->
      ( { test = "foobar" }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
