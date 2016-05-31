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
