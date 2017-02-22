module Map exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Tiles exposing (..)
import Matrix
import Array

-- Model

type alias Model =
    { top : Int
    , left : Int
    , mapData : Matrix.Matrix Int
    , halfWidth : Float
    , halfHeight : Float
    , mapRows : Int
    , mapCols : Int
    , fullMapWidth : Int
    , fullMapHeight : Int
    , mapViewerWindowWidth : Int
    , mapViewerWindowHeight : Int
    -- This is the width and height of the visible portion of the map
    , visibleWidth : Int
    , visibleHeight : Int
    -- overflow width and height are the unseen dimensions of the map
    , overflowWidth : Int
    , overflowHeight : Int
    }

-- object returned by generator API
type alias Maze =
    { height : Int
    , width : Int
    , generator : String
    , mapData : Array.Array (Array.Array Int)
    }

init : Array.Array (Array.Array Int) -> Model
init rawMapData =
  let
    (mr, mc)
      = ( (Array.length rawMapData)
        , case (Array.get 0 rawMapData) of
          Nothing ->
            0
          Just foo ->
            Array.length foo
        )

    ( fmw, fmh ) = ( mc * 32, mr * 32 )
    ( mvww, mvwh ) = ( 640, 640 )
    ( w, h ) = ( case fmw > mvww of
        True -> mvww
        False -> fmw
      , case fmh > mvwh of
          True -> mvwh
          False -> fmh
      )

    ow = fmw - w
    oh = fmh - h
  in
    { top = round -((toFloat oh) / 2)
    , left = round -((toFloat ow) / 2)
    , mapData = rawMapData
    , halfWidth = (toFloat w) / 2
    , halfHeight = (toFloat h) / 2
    , mapRows = mr
    , mapCols = mc
    , fullMapWidth = fmw
    , fullMapHeight = fmh
    , mapViewerWindowWidth = mvww
    , mapViewerWindowHeight = mvwh
    , visibleWidth = w
    , visibleHeight = h
    , overflowWidth = ow
    , overflowHeight = oh
    }

initMaze : Maze
initMaze =
  { height = 0
  , width = 0
  , generator = ""
  , mapData = Array.fromList []
  }


-- Update


type Action
    = VerticalScroll Int
    | HorizontalScroll Int


update : Action -> Model -> Model
update action model =
    case action of
        VerticalScroll i ->
            { model | top = clamp -(model.overflowHeight) 0 (model.top + i) }

        HorizontalScroll i ->
            { model | left = clamp -(model.overflowWidth) 0 (model.left - i) }



-- View


view : Model -> Html msg
view model =
  case ((model.mapRows < 1) || (model.mapCols < 1)) of
    True ->
      renderEmptyMap
    False ->
      renderMap model

renderEmptyMap : Html msg
renderEmptyMap =
  div [] [ Html.text "No map data" ]

renderMap : Model -> Html msg
renderMap model =
  div []
    [ div []
      [ div
        [ style
          [ ( "width", (toString model.visibleWidth) ++ "px" )
          , ( "height", (toString model.visibleHeight) ++ "px" )
          , ( "overflow", "hidden" )
          , ( "border", "2px solid black" )
          ]
        ]
        [ fullMap model ]
      ]
    ]

fullMap : Model -> Html msg
fullMap model =
  div []
    [ div
      [ style
          [ ( "width", (toString model.fullMapWidth) ++ "px" )
          , ( "height", (toString model.fullMapHeight) ++ "px" )
          , ( "position", "relative" )
          , ( "top", (toString model.top) ++ "px" )
          , ( "left", (toString model.left) ++ "px" )
          ]
      ]
      (List.indexedMap (renderMapRow model) (Matrix.toList model.mapData))
    ]

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
