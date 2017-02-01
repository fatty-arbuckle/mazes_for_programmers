module Map exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Tiles exposing (..)
import Matrix
import Array

-- Model

{-| Model contains the offsets of the full map.
--  We only see a part of the map at a time.
-}
type alias Model =
    { top : Int
    , left : Int
    , mapData : Matrix.Matrix Int
    }

type alias Maze =
    { height : Int
    , width : Int
    , generator : String
    , mapData : Matrix.Matrix Int
    }


rawMapData = [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1 ]
             , [ 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1 ]
             , [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ]
             , [ 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1 ]
             , [ 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1 ]
             , [ 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1 ]
             , [ 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1 ]
             , [ 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1 ]
             , [ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 ]
             , [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1 ]
             ]


(mapRows, mapCols)
  = ( (List.length rawMapData)
    , case (List.head rawMapData) of
      Nothing ->
        0
      Just foo ->
        List.length foo
    )

( fullMapWidth, fullMapHeight ) = ( mapCols * 32, mapRows * 32 )

( mapViewerWindowWidth, mapViewerWindowHeight ) = ( 640, 640 )

{-| This is the width and height of the visible portion of the map -}
( width, height )
  = ( case fullMapWidth > mapViewerWindowWidth of
      True -> mapViewerWindowWidth
      False -> fullMapWidth
    , case fullMapHeight > mapViewerWindowHeight of
        True -> mapViewerWindowHeight
        False -> fullMapHeight
    )

( halfWidth, halfHeight ) = ( (toFloat width) / 2, (toFloat height) / 2 )

{-| overflow width and height are the unseen dimensions of the map -}
( overflowWidth, overflowHeight ) = ( fullMapWidth - width, fullMapHeight - height )

{-| We initialize the map to start in approxamitely the center -}
init : Model
init =
    { top = round -((toFloat overflowHeight) / 2)
    , left = round -((toFloat overflowWidth) / 2)
    , mapData = Matrix.fromList rawMapData
    }

initMaze : Maze
initMaze =
  { height = 0
  , width = 0
  , generator = ""
  , mapData = Matrix.fromList []
  }



-- Update


type Action
    = VerticalScroll Int
    | HorizontalScroll Int


update : Action -> Model -> Model
update action model =
    case action of
        VerticalScroll i ->
            { model | top = clamp -overflowHeight 0 (model.top + i) }

        HorizontalScroll i ->
            { model | left = clamp -overflowWidth 0 (model.left - i) }



-- View


view : Model -> Html msg
view model =
  div []
    [ div []
      [ div
        [ style
          [ ( "width", (toString width) ++ "px" )
          , ( "height", (toString height) ++ "px" )
          , ( "overflow", "hidden" )
          , ( "border", "2px solid black" )
          ]
        ]
        [ fullMap model ]
      ]
    ]

fullMap : Model -> Html msg
fullMap model =
    div
        [ style
            [ ( "width", (toString fullMapWidth) ++ "px" )
            , ( "height", (toString fullMapHeight) ++ "px" )
            , ( "position", "relative" )
            , ( "top", (toString model.top) ++ "px" )
            , ( "left", (toString model.left) ++ "px" )
            ]
        ]
        (List.indexedMap (renderMapRow model) (Matrix.toList model.mapData))

renderMapRow : Model -> Int -> List Int -> Html msg
renderMapRow model y row =
  div [ style [ ( "height", "32px" ) ] ] (List.indexedMap (renderMapCell model y) row)

renderMapCell : Model -> Int -> Int -> Int -> Html msg
renderMapCell model y x cell =
  let
    center = Matrix.get (y, x) model.mapData
    north = Matrix.get (y-1, x) model.mapData
    south = Matrix.get (y+1, x) model.mapData
    east  = Matrix.get (y, x+1) model.mapData
    west  = Matrix.get (y, x-1) model.mapData
  in
    Tiles.getTile center north south east west

renderMaze : Maze -> Html msg
renderMaze maze =
  let
    mapRows = Matrix.rowCount maze.mapData
    mapCols = Matrix.colCount maze.mapData

    ( fullMapWidth, fullMapHeight ) = ( mapCols * 32, mapRows * 32 )
    ( mapViewerWindowWidth, mapViewerWindowHeight ) = ( 640, 640 )
    ( width, height )
      = ( case fullMapWidth > mapViewerWindowWidth of
            True -> mapViewerWindowWidth
            False -> fullMapWidth
        , case fullMapHeight > mapViewerWindowHeight of
            True -> mapViewerWindowHeight
            False -> fullMapHeight
        )

    ( halfWidth, halfHeight ) = ( (toFloat width) / 2, (toFloat height) / 2 )
    ( overflowWidth, overflowHeight ) = ( fullMapWidth - width, fullMapHeight - height )

    top = round -((toFloat overflowHeight) / 2)
    left = round -((toFloat overflowWidth) / 2)
  in
    div []
      [ div [] []
      -- , Html.dl []
      --   [ Html.dt [] [ Html.text "height" ], Html.dd [] [ Html.text (toString maze.height) ]
      --   , Html.dt [] [ Html.text "width" ], Html.dd [] [ Html.text (toString maze.width) ]
      --   , Html.dt [] [ Html.text "generator" ], Html.dd [] [ Html.text maze.generator ]
      --   , Html.dt [] [ Html.text "mapRows" ], Html.dd [] [ Html.text (toString mapRows) ]
      --   , Html.dt [] [ Html.text "mapCols" ], Html.dd [] [ Html.text (toString mapCols) ]
      --   , Html.dt [] [ Html.text "fullMapWidth" ], Html.dd [] [ Html.text (toString fullMapWidth) ]
      --   , Html.dt [] [ Html.text "fullMapHeight" ], Html.dd [] [ Html.text (toString fullMapHeight) ]
      --   , Html.dt [] [ Html.text "mapViewerWindowWidth" ], Html.dd [] [ Html.text (toString mapViewerWindowWidth) ]
      --   , Html.dt [] [ Html.text "mapViewerWindowHeight" ], Html.dd [] [ Html.text (toString mapViewerWindowHeight) ]
      --   , Html.dt [] [ Html.text "width" ], Html.dd [] [ Html.text (toString width) ]
      --   , Html.dt [] [ Html.text "height" ], Html.dd [] [ Html.text (toString height) ]
      --   , Html.dt [] [ Html.text "halfWidth" ], Html.dd [] [ Html.text (toString halfWidth) ]
      --   , Html.dt [] [ Html.text "halfHeight" ], Html.dd [] [ Html.text (toString halfHeight) ]
      --   , Html.dt [] [ Html.text "overflowWidth" ], Html.dd [] [ Html.text (toString overflowWidth) ]
      --   , Html.dt [] [ Html.text "overflowHeight" ], Html.dd [] [ Html.text (toString overflowHeight) ]
      --   , Html.dt [] [ Html.text "top" ], Html.dd [] [ Html.text (toString top) ]
      --   , Html.dt [] [ Html.text "left" ], Html.dd [] [ Html.text (toString left) ]
      --   ]

      , div
        [ style
          [ ( "width", (toString fullMapWidth) ++ "px" )
          , ( "height", (toString fullMapHeight) ++ "px" )
          , ( "position", "relative" )
          , ( "top", (toString top) ++ "px" )
          , ( "left", (toString left) ++ "px" )
          ]
        ]
        (List.indexedMap (renderMazeRow maze) (Matrix.toList maze.mapData))
      ]

renderMazeRow : Maze -> Int -> List Int -> Html msg
renderMazeRow model y row =
  div [ style [ ( "height", "32px" ) ] ] (List.indexedMap (renderMazeCell model y) row)

renderMazeCell : Maze -> Int -> Int -> Int -> Html msg
renderMazeCell model y x cell =
  let
    center = Matrix.get (y, x) model.mapData
    north = Matrix.get (y-1, x) model.mapData
    south = Matrix.get (y+1, x) model.mapData
    east  = Matrix.get (y, x+1) model.mapData
    west  = Matrix.get (y, x-1) model.mapData
  in
    Tiles.getTile center north south east west
