module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Models exposing (AppModel, initialModel)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias AppModel =
    {}


init : String -> ( AppModel, Cmd Msg )
init topic =
    let
        cmds =
            []

        cmd =
            Cmd.batch cmds
    in
        (Models.initialModel cmd)



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none
