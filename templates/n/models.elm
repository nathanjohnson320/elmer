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
