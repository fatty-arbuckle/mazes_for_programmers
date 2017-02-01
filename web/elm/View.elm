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
    -- [ div []
    --   [ Html.h2 [] [Html.text model.httpCats.topic]
    --   , Html.button [ Html.Events.onClick HttpCats.MorePlease ] [ Html.text "More Please!" ]
    --   , Html.br [] []
    --   , Html.img [Html.Attributes.src model.httpCats.gifUrl] []
    --   ]
    -- , Html.map (\_ -> Types.Nothing) (HttpCats.view model.httpCats)
    [ div [ style [ ( "width", (toString Map.width) ++ "px" ) ] ]
      [ Html.map (\_ -> Types.Nothing) (Map.view model.map)
      , Html.map (\_ -> Types.Nothing) (Sprite.view model.sprite)
      ]
    ]
