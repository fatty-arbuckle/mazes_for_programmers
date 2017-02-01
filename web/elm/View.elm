module View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events

import Types exposing (..)

import Map
import Sprite

view : Model -> Html Msg
view model =
  div []
    [ renderErrors model.errors

    , renderGenerators model.generators

    -- render map
    , div [ style [ ( "width", (toString Map.width) ++ "px" ) ] ]
      [ Html.map (\_ -> Types.Nothing) (Map.view model.map)
      , Html.map (\_ -> Types.Nothing) (Sprite.view model.sprite)
      ]

    -- maze data
    , div [] [ Html.map (\_ -> Types.Nothing) (Map.renderMaze model.maze) ]
    ]

renderErrors : List String -> Html Msg
renderErrors errors =
  div [] (List.map renderError errors)

renderError : String -> Html Msg
renderError error =
  div [ ] [ Html.text error ]


renderGenerators : List String -> Html Msg
renderGenerators generators =
  case generators of
    [] ->
      Html.button [ Html.Events.onClick LoadGenerators ] [ Html.text "Load Generators" ]
    _ ->
      div [] (List.map renderGenerator generators)

renderGenerator : String -> Html Msg
renderGenerator generator =
  Html.button [ Html.Events.onClick (GenerateMaze generator) ] [ Html.text generator ]
