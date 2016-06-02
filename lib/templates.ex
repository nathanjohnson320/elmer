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

type alias <%= @model_name %> =
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>    <%= if index == 0 do %>{<%= else %>,<% end %> <%= field["field"] %> : <%= field["type"] %>
<% end %>    }

new : <%= @model_name %>
<%= Enum.map Enum.with_index(@fields), fn({field, index}) -> %>    <%= if index == 0 do %>{<%= else %>,<% end %> <%= field["field"] %> : <%= field["default_value"] %>
<% end %>    }
"""
  end
end
