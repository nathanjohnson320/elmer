defmodule Elmer.Templates do
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
end
