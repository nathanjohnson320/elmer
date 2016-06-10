defmodule Elmer.Templates do
  @moduledoc """
  Contains eex template strings for each of the elm types. Placed templates in heredocs instead of files to avoid cross project/OS file system issues.
  """
  def render_msgs do
    """
module <%= @modulename %>.Msgs exposing (..)


type Msg
\s\s\s\s= NoOp
<%= Enum.map @messages, fn(msg) -> %>\s\s\s\s| <%= msg["msg"] %> <%= Enum.map msg["params"], fn(param) -> %><%= param %> <% end %>
<% end %>
    """
  end

  def render_model do
    """
module <%= @modulename %>.Models exposing (..)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


-- Model Declaration


type alias <%= @model_name %> =
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>    <%= if index == 0 do %>{<%= else %>,<% end %> <%= field["field"] %> : <%= field["type"] %>
<% end %>    }



-- New Model


new : <%= @model_name %>
new =
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>    <%= if index == 0 do %>{<%= else %>,<% end %> <%= field["field"] %> : <%= field["default_value"] %>
<% end %>    }



-- JSON Decoder


<%= String.downcase(@model_name) %>Decoder : Decode.Decoder <%= @model_name %>
<%= String.downcase(@model_name) %>Decoder =
    Decode.object<%= length(@fields) %> <%= @model_name %>
<%= Enum.map @fields, fn(field) -> %>        ("<%= field["field"]%>" := Decode.<%= String.downcase(field["type"]) %>)
<% end %>


-- JSON Encoder


<%= String.downcase(@model_name) %>Encoded : <%= @model_name %> -> Encode.Value
<%= String.downcase(@model_name) %>Encoded model =
    Encode.object
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>        <%= if index == 0 do %>[<%= else %>,<% end %> ( "<%= field["field"] %>", Encode.<%= String.downcase(field["type"]) %> model.<%= field["field"] %> )
<% end %>        ]

"""
  end

  def render_view do
    """
module <%= @module_name %>.View exposing (..)

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

  def render_update do
    """
module <%= @module_name %>.Update exposing (..)

import <%= @module_name %>.Models exposing (..)
import <%= @module_name %>.Msgs exposing (..)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
<%= Enum.map @clauses, fn(clause) -> %>        <%= clause["msg"] %><%= Enum.map clause["params"], fn(param) -> %> <%= param %><% end %> ->
            ( model, Cmd.none )

<% end %>
"""
  end

  def render_cmd do
    """
module <%= @module_name %>.Cmd exposing (..)

import Platform.Cmd as Cmd exposing (..)
import Http
import Task
import <%= @module_name %>.Models exposing (<%= @model %>, collectionDecoder)
import <%= @module_name %>.Msgs exposing (..)

<%= Enum.map @cmds, fn(cmd) -> %>
<%= String.downcase(cmd["cmd"]) %> : <%= Enum.map cmd["params"], fn(param) -> %><%= param %> -> <% end %>Cmd Msg
<%= String.downcase(cmd["cmd"])%> <%= Enum.map cmd["params"], fn(param) -> %><%= String.downcase(param) %> <% end %>=
<%= case cmd["request"] do %>
<% "GET" -> %>    Task.perform <%= cmd["cmd"] %>Error <%= cmd["cmd"] %>Success (Http.get collectionDecoder <%= String.downcase(cmd["cmd"]) %>Url)
<% _ -> %>    let
        body =
            ""
                |> Encode.encode 0
                |> Http.string

        config =
            { verb = "<%= cmd["request"] %>"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = createUrl
            , body = body
            }

        request =
            Http.send Http.defaultSettings config
                |> Http.fromJson <%= String.downcase(@model) %>Decoder
    in
        Task.perform CreatePlayerError CreatePlayerSuccess (request)
<% end %>

<%= String.downcase(cmd["cmd"]) %>Url : String
<%= String.downcase(cmd["cmd"]) %>Url =
    ""
<% end %>
"""
  end

  def render_port do
    """
port module <%= @module_name %>.Ports exposing (..)

<%= Enum.map @ports, fn(port) -> %>
<%= case port["direction"] do %>
<% "inbound" -> %>port <%= port["name"] %> : ( <%= Enum.join port["params"], ", " %> -> msg ) -> Sub msg
<% "outbound" -> %>port <%= port["name"] %> : ( <%= Enum.join port["params"], ", " %> ) -> Cmd msg
<% end %>
<% end %>
subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none
<%= Enum.map @ports, fn(port) -> %><%= case port["direction"] do %>
<% "inbound" -> %>        , <%= port["name"] %> Msg
<% _ -> %><% end %><% end %>        ]
"""
  end

  def render_list_view do
    """
module <%= @module_name %>.List exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import <%= @module_name %>.Msgs exposing (..)
import <%= @module_name %>.Models exposing (<%= @model_name %>)


type alias ViewModel =
    { <%= @model_plural %> : List <%= @model_name %>
    , errorMessage : String
    }


view : ViewModel -> Html Msg
view model =
    div []
        [ div [] [ text model.errorMessage ]
        , list model
        ]


list : ViewModel -> Html Msg
list model =
    div []
        [ table []
            [ thead []
                [ tr []
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>                    <%= if index == 0 do %>[<%= else %>,<% end %> th [] [ text "<%= field["field"] %>" ]
<% end %>                    ]
                ]
            , tbody [] (List.map (<%= String.downcase @model_name %>Row model) model.<%= @model_plural %>)
            ]
        ]


<%= String.downcase @model_name %>Row : ViewModel -> <%= @model_name %> -> Html Msg
<%= String.downcase @model_name %>Row model <%= String.downcase @model_name %> =
    tr []
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>        <%= if index == 0 do %>[<%= else %>,<% end %> td [] [ text <%= String.downcase @model_name %>.<%= field["field"] %> ]
<% end %>        , td []
            [ editBtn <%= String.downcase @model_name %>
            , deleteBtn <%= String.downcase @model_name %>
            ]
        ]


editBtn : <%= @model_name %> -> Html Msg
editBtn <%= String.downcase @model_name %> =
    button
        [ class ""
        , onClick (EditPlayer <%= String.downcase @model_name %>.id)
        ]
        [ i [ class "" ] [], text "Edit" ]


addBtn : ViewModel -> Html Msg
addBtn model =
    button [ class "", onClick Create<%= @model_name %> ]
        [ i [ class "" ] []
        , text "Add <%= String.downcase @model_name %>"
        ]


deleteBtn : <%= @model_name %> -> Html Msg
deleteBtn <%= String.downcase @model_name %> =
    button
        [ class ""
        , onClick (Delete<%= @model_name %> <%= String.downcase @model_name %>)
        ]
        [ i [ class "" ] [], text "Delete" ]
"""
  end

  def render_edit_view() do
    """
module <%= @module_name %>.Edit exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class, value, href)
import Html.Events exposing (onClick, onInput, on)
import Json.Decode as Json
import <%= @module_name %>.Msgs exposing (..)
import <%= @module_name %>.Models exposing (<%= @model_name %>)


type alias ViewModel =
    { player : Player
    }
type alias ViewModel =
    { <%= String.downcase @model_name %> : <%= @model_name %>
    , errorMessage : String
    }

onChange : msg -> Attribute msg
onChange message =
    on "change" (Json.succeed message)


view : ViewModel -> Html Msg
view model =
    div []
        [ div [] [ text model.errorMessage]
        , form model
        ]


form : ViewModel -> Html Msg
form model =
    div []
        [ formLevel model
        , formName model
        ]


formName : ViewModel -> Html Msg
formName model =
    div
        [ class ""
        ]
        [ div [ class "" ] [ text "Name" ]
        , div [ class "" ]
            [ inputName model
            ]
        ]


inputName : ViewModel -> Html Msg
inputName model =
    input
        [ class ""
        , value model.player.name
        , onChange (ChangeName model.player.id)
        ]
        []
"""
  end
end
