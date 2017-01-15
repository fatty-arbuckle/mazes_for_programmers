module State exposing (init, update, subscriptions)

import Types exposing (..)
import Keyboard.Extra
import Sprite
import Map
import Time exposing (Time)
import AnimationFrame

init : ( Model, Cmd Msg)
init =
  let
    ( initialKeyboard, keyboardCmd ) = Keyboard.Extra.init
  in
    ( (initModel initialKeyboard), Cmd.map KeyPress keyboardCmd )



initModel : Keyboard.Extra.Model -> Model
initModel keyboard =
    Model Sprite.init Map.init keyboard



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick timeDelta ->
            ( model
                |> updateMap timeDelta
                |> updateSprite (Sprite.Tick timeDelta)
            , Cmd.none
            )

        KeyPress key ->
            let
                ( keyboard, _ ) =
                    Keyboard.Extra.update key model.keyboard

                direction =
                    Keyboard.Extra.arrows keyboard
            in
                ( { model | keyboard = keyboard }
                    |> updateSprite (Sprite.Direction direction)
                , Cmd.none
                )

        Types.Nothing ->
            ( model, Cmd.none )

-- Move to Sprite.elm
updateSprite : Sprite.Msg -> Model -> Model
updateSprite msg model =
    let
        sprite_ =
            Sprite.update msg model.sprite
    in
        { model | sprite = sprite_ }


-- Move to Map.elm
updateMap : Time -> Model -> Model
updateMap dt model =
    let
        ( x, y, vx, vy, map ) =
            ( model.sprite.x, model.sprite.y, model.sprite.vx, model.sprite.vy, model.map )

        ( bottomWall, leftWall, rightWall, topWall ) =
            ( 0, 0, (toFloat Map.width), (toFloat Map.height) )

        ( movingUp, movingDown, movingRight, movingLeft ) =
            ( vy > 0, vy < 0, vx > 0, vx < 0 )

        action : Map.Action
        action =
            if x == leftWall && movingLeft then
                Map.HorizontalScroll (round (dt * vx))
            else if (x + 32) == rightWall && movingRight then
                Map.HorizontalScroll (round (dt * vx))
            else if y == topWall && movingUp then
                Map.VerticalScroll (round (dt * vy))
            else if (y - 32) == bottomWall && movingDown then
                Map.VerticalScroll (round (dt * vy))
            else
                Map.HorizontalScroll 0
    in
      { model | map = Map.update action map }


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [ Sub.map KeyPress Keyboard.Extra.subscriptions
    , AnimationFrame.diffs Tick
    ]
