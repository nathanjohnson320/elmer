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
