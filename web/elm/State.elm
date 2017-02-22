module State exposing (init, update, subscriptions)

import Types exposing (..)
import Keyboard.Extra
import Sprite
import Map
import Time exposing (Time)
import AnimationFrame
import Json.Decode
import Http
import Matrix
import Array

init : ( Model, Cmd Msg)
init =
  let
    ( initialKeyboard, keyboardCmd ) = Keyboard.Extra.init
  in
    ( ( initModel initialKeyboard ), Cmd.map KeyPress keyboardCmd )



initModel : Keyboard.Extra.Model -> Model
initModel keyboard =
  let
    generators = []
    mapModel = Map.init (Array.fromList [])
  in
    Model
      (Sprite.init mapModel)
      mapModel
      keyboard
      generators
      []
      Map.initMaze



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
        ( keyboard, _ ) = Keyboard.Extra.update key model.keyboard
        direction = Keyboard.Extra.arrows keyboard
      in
        ( { model | keyboard = keyboard }
          |> updateSprite (Sprite.Direction direction)
        , Cmd.none
      )

    Types.Nothing ->
      ( model, Cmd.none )

    LoadGenerators ->
      ( model, loadGenerators )

    ReceivedGenerators (Ok generators) ->
      ( { model | generators = (model.generators ++ generators) }, Cmd.none )

    ReceivedGenerators (Err error) ->
      let
        message = httpErrorMessage error
      in
        ( { model | errors = model.errors ++ [message] }, Cmd.none )

    GenerateMaze generator ->
      ( model, generateMaze generator )

    ReceivedMaze (Ok maze) ->
      let
        newMap = Map.init maze.mapData
      in
        ( { model | map = newMap, sprite = Sprite.init newMap, maze = maze }, Cmd.none )

    ReceivedMaze (Err error) ->
      let
        message = httpErrorMessage error
      in
        ( { model | errors = model.errors ++ [message] }, Cmd.none )


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
            ( 0, 0, (toFloat model.map.visibleWidth), (toFloat model.map.visibleHeight) )

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


httpErrorMessage : Http.Error -> String
httpErrorMessage error =
  case error of
    Http.Timeout -> "request timed out"
    Http.NetworkError -> "a network error occurred"
    Http.BadPayload s _ -> "payload error: " ++ s
    Http.BadStatus _ -> "bad status!"
    Http.BadUrl _ -> "bad status!"



loadGenerators : Cmd Msg
loadGenerators =
  let
    url = "http://localhost:4000/api/generators"
  in
    Http.send ReceivedGenerators (Http.get url decodeGenerators)

decodeGenerators : Json.Decode.Decoder (List String)
decodeGenerators =
  Json.Decode.at ["data"] (Json.Decode.list Json.Decode.string)


generateMaze: String -> Cmd Msg
generateMaze generator =
  let
    url = "http://localhost:4000/api/mazes/" ++ generator
  in
    Http.send ReceivedMaze (Http.get url decodeMaze)

decodeMaze : Json.Decode.Decoder Map.Maze
decodeMaze =
  Json.Decode.at ["data"] decodeMap

decodeMap : Json.Decode.Decoder Map.Maze
decodeMap =
  Json.Decode.map4 Map.Maze
    (Json.Decode.at ["width"] Json.Decode.int)
    (Json.Decode.at ["height"] Json.Decode.int)
    (Json.Decode.at ["generator"] Json.Decode.string)
    (Json.Decode.at ["maze"] decodeMazeData)

decodeMazeData : Json.Decode.Decoder (Array.Array (Array.Array Int))
decodeMazeData =
  Json.Decode.array (Json.Decode.array Json.Decode.int)

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [ Sub.map KeyPress Keyboard.Extra.subscriptions
    , AnimationFrame.diffs Tick
    ]
