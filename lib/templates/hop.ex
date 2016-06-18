defmodule Elmer.Templates.Hop do
  @moduledoc """
  Renders an elm-html application with navigation leveraging sporto/Hop. Use this if you want to build a single page application. Documentation here: https://github.com/sporto/hop
  """
  def render_main do
  """
module Main exposing (..)

import Html.App as App
import Navigation
import View exposing (view)
import Models exposing (AppModel, initialModel)
import Update exposing (update)
import Navigation
import Routing exposing (urlParser, urlUpdate)
import RouteMsgs exposing (..)
import Msgs exposing (Msg)
import Ports exposing (subscriptions)
import Hop.Types


-- MAIN


init : ( Route, Hop.Types.Location ) -> ( AppModel, Cmd Msg )
init ( route, location ) =
    let
        cmds =
            []

        cmd =
            Cmd.batch cmds
    in
        ( Models.initialModel location route, cmd )


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
  """
  end

  def render_package_json do
    """
{
    "version": "1.0.0",
    "summary": "helpful summary of your project, less than 80 characters",
    "repository": "https://github.com/user/project.git",
    "license": "BSD3",
    "source-directories": [
        "."
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "4.0.0 <= v < 5.0.0",
        "elm-lang/html": "1.0.0 <= v < 2.0.0",
        "elm-lang/navigation": "1.0.0 <= v < 2.0.0",
        "evancz/elm-http": "3.0.1 <= v < 4.0.0",
        "sporto/hop": "5.0.1 <= v < 6.0.0"
    },
    "elm-version": "0.17.0 <= v < 0.18.0"
}
"""
  end

  def render_models do
    """
module Models exposing (..)

import RouteMsgs exposing (Route)
import Hop.Types exposing (Location, Router)


type alias AppModel =
    { location : Location
    , route : Route
    }


initialModel : Location -> Route -> AppModel
initialModel location route =
    { location = location
    , route = route
    }
"""
  end

  def render_msgs do
"""
module Msgs exposing (..)

import Hop.Types exposing (Query)

type Msg
    = NoOp
    | NavigateTo String
    | SetQuery Query
"""
  end

  def render_ports do
    """
port module Ports exposing (..)

import Models exposing (AppModel)
import Msgs exposing (..)


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none
        ]
"""
  end

  def render_routemsgs do
    """
module RouteMsgs exposing (..)

{-|
Define your routes as union types
You need to provide a route for when the current URL doesn't match any known route i.e. NotFoundRoute
-}


type Route
    = AboutRoute
    | MainRoute
    | NotFoundRoute
"""
  end

  def render_routing do
    """
module Routing exposing (..)

import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)
import Hop.Matchers exposing (..)
import Msgs exposing (..)
import RouteMsgs exposing (..)
import Models exposing (AppModel)


-- ROUTES


{-|
Define matchers
For example:
    match1 AboutRoute "/about"
Will match "/about" and return AboutRoute
    match2 UserRoute "/users/" int
Will match "/users/1" and return (UserRoute 1)
`int` is a matcher that matches only integers, for a string use `str` e.g.
    match2 UserRoute "/users/" str
Would match "/users/abc"
-}
matchers : List (PathMatcher Route)
matchers =
    [ match1 MainRoute ""
    , match1 AboutRoute "/about"
    ]


{-|
Define your router configuration
Use `hash = True` for hash routing e.g. `#/users/1`
Use `hash = False` for push state e.g. `/users/1`
The `basePath` is only used for path routing.
This is useful if you application is not located at the root of a url e.g. `/app/v1/users/1` where `/app/v1` is the base path.
- `matchers` is your list of matchers defined above.
- `notFound` is a route that will be returned when the path doesn't match any known route.
-}
routerConfig : Config Route
routerConfig =
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFoundRoute
    }


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl routerConfig)


urlUpdate : ( Route, Hop.Types.Location ) -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate ( route, location ) model =
    ( { model | route = route, location = location }, Cmd.none )
"""
  end

  def render_update do
    """
module Update exposing (..)

import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, setQuery)
import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (routerConfig)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        NavigateTo path ->
            let
                command =
                    makeUrl routerConfig path
                        |> Navigation.modifyUrl
            in
                ( model, command )

        SetQuery query ->
            let
                command =
                    model.location
                        |> setQuery query
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.modifyUrl
            in
                ( model, command )

        NoOp ->
            ( model, Cmd.none )
"""
  end

  def render_view do
    """
module View exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Dict
import Msgs exposing (..)
import RouteMsgs exposing (..)
import Models exposing (..)


view : AppModel -> Html Msg
view model =
    div []
        [ menu model
        , pageView model
        ]


menu : AppModel -> Html Msg
menu model =
    div []
        [ div []
            [ button
                [ class "btnMain"
                , onClick (NavigateTo "")
                ]
                [ text "Main" ]
            , button
                [ class "btnAbout"
                , onClick (NavigateTo "about")
                ]
                [ text "About" ]
            , button
                [ class "btnQuery"
                , onClick (SetQuery (Dict.singleton "keyword" "elm"))
                ]
                [ text "Set query string" ]
            , currentQuery model
            ]
        ]


currentQuery : AppModel -> Html msg
currentQuery model =
    let
        query =
            toString model.location.query
    in
        span [ class "labelQuery" ]
            [ text query ]


{-|
Views can decide what to show using `model.route`.
-}
pageView : AppModel -> Html msg
pageView model =
    case model.route of
        MainRoute ->
            div [] [ h2 [ class "title" ] [ text "Main" ] ]

        AboutRoute ->
            div [] [ h2 [ class "title" ] [ text "About" ] ]

        NotFoundRoute ->
            div [] [ h2 [ class "title" ] [ text "Not found" ] ]
"""
  end
end
