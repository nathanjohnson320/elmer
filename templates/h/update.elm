module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
