defmodule Elmer.Templates.Navigation do
  @moduledoc """
  Renders an elm-html application with navigation. Use this if you want to build a single page application. Documentation here: http://package.elm-lang.org/packages/elm-lang/navigation/1.0.0/Navigation#program
  """
  def render_main do
  """
module Main exposing (..)

import Html.App as App
import Navigation
import View exposing (view)
import Models exposing (AppModel, initialModel)
import Update exposing (update)
import Routing exposing (hashParser, urlUpdate, urlInit)
import RouteMsgs exposing (..)
import Msgs exposing (Msg)
import Ports exposing (subscriptions)


-- MAIN


init : Result String Page -> ( AppModel, Cmd Msg )
init result =
    let
        cmds =
            []

        cmd =
            Cmd.batch cmds
    in
        urlInit result Models.initialModel cmd


main =
    Navigation.program (Navigation.makeParser hashParser)
        { init = init
        , update = update
        , view = view
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
    "evancz/url-parser": "1.0.0 <= v < 2.0.0"
  },
  "elm-version": "0.17.0 <= v < 0.18.0" 
}
"""
  end

  def render_models do
    """
module Models exposing (..)

import RouteMsgs exposing (..)


type alias AppModel =
    { page : Page
    , query : String
    }


initialModel : AppModel
initialModel =
    { page = Index
    , query = ""
    }
"""
  end

  def render_msgs do
"""
module Msgs exposing (..)


type Msg
    = NoOp
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


type Page
    = Index
"""
  end

  def render_routing do
    """
module Routing exposing (..)

import Navigation
import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import RouteMsgs exposing (..)
import Models exposing (AppModel)
import Msgs exposing (Msg)


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ format Index (s "/")
        ]


urlInit : Result String Page -> AppModel -> Cmd Msg -> ( AppModel, Cmd Msg )
urlInit result model cmd =
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toHash model.page) )

        Ok page ->
            ( { model | page = page, query = "" }, cmd )


urlUpdate : Result String Page -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate result model =
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toHash model.page) )

        Ok page ->
            ({ model | page = page, query = "" } ! [])


toHash : Page -> String
toHash page =
    case page of
        Index ->
            "#/"


hashParser : Navigation.Location -> Result String Page
hashParser location =
    UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)
"""
  end

  def render_update do
    """
module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
"""
  end

  def render_view do
    """
module View exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Msgs exposing (..)
import RouteMsgs exposing (..)
import Models exposing (..)


view : AppModel -> Html Msg
view model =
    div []
        [ text "Hello, World!" ]
"""
  end
end
