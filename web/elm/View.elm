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

    , renderGenerators model

    -- render map
    , div [ style [ ( "width", (toString model.map.visibleWidth) ++ "px" ) ] ]
      [ Html.map (\_ -> Types.Nothing) (Map.view model.map)
      , Html.map (\_ -> Types.Nothing) (Sprite.view model.sprite)
      ]
    ]

renderErrors : List String -> Html Msg
renderErrors errors =
  div [] (List.map renderError errors)

renderError : String -> Html Msg
renderError error =
  div [ ] [ Html.text error ]


renderGenerators : Model -> Html Msg
renderGenerators model =
  case model.generators of
    [] ->
      Html.button [ Html.Events.onClick LoadGenerators ] [ Html.text "Load Generators" ]
    _ ->
      div []
        [ div [] (List.map renderGenerator model.generators)
        , renderRowsColumns model
        ]

renderGenerator : String -> Html Msg
renderGenerator generator =
  Html.button [ Html.Events.onClick (GenerateMaze generator) ] [ Html.text generator ]

renderRowsColumns : Model -> Html Msg
renderRowsColumns model =
  div []
    [ Html.input
      [ Html.Attributes.placeholder ("columns = " ++ (toString model.columns))
      , Html.Events.onInput InputColumns
      ] []
    , Html.input
      [ Html.Attributes.placeholder ("rows = " ++ (toString model.rows))
      , Html.Events.onInput InputRows
      ] []
    ]
