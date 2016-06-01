defmodule Elmer.Templates.Html do
  def render_main do
    """
module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Models exposing (AppModel, initialModel)
import View exposing (view)
import Update exposing (update)
import Msgs exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( AppModel, Cmd Msg )
init =
    let
        cmds =
            []

        cmd =
            Cmd.batch cmds
    in
        ( Models.initialModel, cmd )



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none
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
    "elm-lang/html": "1.0.0 <= v < 2.0.0"
  },
  "elm-version": "0.17.0 <= v < 0.18.0" 
}
"""
  end

  def render_models do
    """
module Models exposing (..)


type alias AppModel =
    {}


initialModel : AppModel
initialModel =
    {}
"""
  end

  def render_msgs do
    """
module Msgs exposing (..)


type Msg
    = NoOp
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
import Models exposing (..)


view : AppModel -> Html Msg
view model =
    div []
        [ text "Hello, World!" ]
"""
  end
end
