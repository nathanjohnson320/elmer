defmodule Elmer.Templates do
  def render_msgs do
    """
module Msgs exposing (..)


type Msg
    = NoOp
<%= Enum.map @messages, fn(msg) -> %>
| <%= msg["msg"] %><%= Enum.map msg["params"], fn(param) -> %><%= param %> <% end %><% end %>
    """
  end
end
