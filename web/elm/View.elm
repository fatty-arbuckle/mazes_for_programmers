module View exposing (view)

import Html exposing (Html, div)
import Html.App
import Html.Attributes exposing (style)


import Types exposing (..)

import Map
import Sprite

view : Model -> Html Msg
view model =
  div [ style [ ( "width", (toString Map.width) ++ "px" ) ] ]
    [ Html.App.map (\_ -> Types.Nothing) (Map.view model.map)
    , Html.App.map (\_ -> Types.Nothing) (Sprite.view model.sprite)
    ]
