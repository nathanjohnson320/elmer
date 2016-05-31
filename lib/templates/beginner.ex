defmodule Elmer.Templates.Beginner do
  def render_main do
  """
  module Main exposing (..)

import Html exposing (Html, Attribute, div, text)
import Html.App as Html
import Html.Attributes exposing (..)
import String


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    {}


model : Model
model =
    {}



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text "Hello, world!" ]
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
end
