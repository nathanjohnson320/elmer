port module Ports exposing (..)

import Models exposing (AppModel)
import Msgs exposing (..)


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none
        ]
