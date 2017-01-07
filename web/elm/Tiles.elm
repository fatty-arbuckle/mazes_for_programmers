module Tiles exposing (..)

import Html exposing (Html, div, img)
import Html.Attributes exposing (src, style)

import Array
import Matrix

-- Path Sprite

tileFromSpriteSheet : ( Int, Int ) -> Html msg
tileFromSpriteSheet =
    imgFromSpriteSheet "images/terrain.png"

tilesList = Array.fromList
  [ tileFromSpriteSheet ( 0 * 32, 0 * 32 ) --  0
  , tileFromSpriteSheet ( 1 * 32, 0 * 32 ) --  1
  , tileFromSpriteSheet ( 2 * 32, 0 * 32 ) --  2
  , tileFromSpriteSheet ( 3 * 32, 0 * 32 ) --  3
  , tileFromSpriteSheet ( 4 * 32, 0 * 32 ) --  4
  , tileFromSpriteSheet ( 5 * 32, 0 * 32 ) --  5
  , tileFromSpriteSheet ( 6 * 32, 0 * 32 ) --  6
  , tileFromSpriteSheet ( 0 * 32, 1 * 32 ) --  7
  , tileFromSpriteSheet ( 1 * 32, 1 * 32 ) --  8
  , tileFromSpriteSheet ( 2 * 32, 1 * 32 ) --  9
  , tileFromSpriteSheet ( 3 * 32, 1 * 32 ) -- 10
  , tileFromSpriteSheet ( 4 * 32, 1 * 32 ) -- 11
  , tileFromSpriteSheet ( 5 * 32, 1 * 32 ) -- 12
  , tileFromSpriteSheet ( 6 * 32, 1 * 32 ) -- 13
  , tileFromSpriteSheet ( 0 * 32, 2 * 32 ) -- 14
  , tileFromSpriteSheet ( 1 * 32, 2 * 32 ) -- 15
  , tileFromSpriteSheet ( 2 * 32, 2 * 32 ) -- 16
  , tileFromSpriteSheet ( 3 * 32, 2 * 32 ) -- 17
  , tileFromSpriteSheet ( 4 * 32, 2 * 32 ) -- 18
  , tileFromSpriteSheet ( 5 * 32, 2 * 32 ) -- 19
  , tileFromSpriteSheet ( 6 * 32, 2 * 32 ) -- 20
  , tileFromSpriteSheet ( 0 * 32, 3 * 32 ) -- 21
  , tileFromSpriteSheet ( 1 * 32, 3 * 32 ) -- 22
  , tileFromSpriteSheet ( 2 * 32, 3 * 32 ) -- 23
  , tileFromSpriteSheet ( 3 * 32, 3 * 32 )
  , tileFromSpriteSheet ( 4 * 32, 3 * 32 )
  , tileFromSpriteSheet ( 5 * 32, 3 * 32 )
  , tileFromSpriteSheet ( 6 * 32, 3 * 32 )
  , tileFromSpriteSheet ( 0 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 1 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 2 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 3 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 4 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 5 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 6 * 32, 4 * 32 )
  , tileFromSpriteSheet ( 0 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 1 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 2 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 3 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 4 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 5 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 6 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 7 * 32, 5 * 32 )
  , tileFromSpriteSheet ( 0 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 1 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 2 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 3 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 4 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 5 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 6 * 32, 6 * 32 )
  , tileFromSpriteSheet ( 7 * 32, 6 * 32 )
  ]

imgFromSpriteSheet : String -> ( Int, Int ) -> Html msg
imgFromSpriteSheet spriteSheet ( x, y ) =
  img
    [ src "images/empty.png"
    , style
      [ ( "width", "32px" )
      , ( "height", "32px" )
      , ( "background-image", "url(" ++ spriteSheet ++ ")" )
      , ( "background-position"
        , "-" ++ (toString x) ++ "px -" ++ (toString y) ++ "px"
        )
      ]
    ]
    []

tiles16 = Array.fromList [ 16, 7, 6, 3, 5, 11, 9, 12, 4, 10, 8, 13, 2, 14, 15, 1 ]

northValue : Maybe Int -> Int
northValue i =
  case i of
    Nothing -> 0
    Just 0 -> 0
    Just v -> 1

southValue : Maybe Int -> Int
southValue i =
  case i of
    Nothing -> 0
    Just 0 -> 0
    Just v -> 2

eastValue : Maybe Int -> Int
eastValue i =
  case i of
    Nothing -> 0
    Just 0 -> 0
    Just v -> 8

westValue : Maybe Int -> Int
westValue i =
  case i of
    Nothing -> 0
    Just 0 -> 0
    Just v -> 4

getTile : Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> Html msg
getTile center north south east west =
  let
    nv = northValue north
    sv = southValue south
    ev = eastValue east
    wv = westValue west
    cellValue = nv + sv + ev + wv
    tileIndex = case cellValue of
      0 -> Just 0
      _ -> Array.get cellValue tiles16
    index = case tileIndex of
      Nothing -> 0
      Just i -> i
    realIndex = case center of
      Just 0 -> 0
      _ -> index
  in
    case Array.get realIndex tilesList of
      Nothing ->
        img
          [ src "images/error.png"
          , style [ ( "width", "32px" ), ( "height", "32px" ) ]
          ]
          []
      Just tile ->
        tile
        -- Html.span
          -- [ style [ ("border", "2px solid"), ("padding", "2px") ] ]
          -- [ Html.text (toString index) ]
          -- [ Html.text (toString (nv + sv + ev + wv)) ]
          -- [ Html.text (toString nv)
          -- , Html.text (toString sv)
          -- , Html.text (toString ev)
          -- , Html.text (toString wv)
          -- ]
