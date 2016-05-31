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
