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
