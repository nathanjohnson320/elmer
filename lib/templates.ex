defmodule Elmer.Templates do
  def render_msgs do
    """
module Msgs exposing (..)


type Msg
\s\s\s\s= NoOp
<%= Enum.map @messages, fn(msg) -> %>\s\s\s\s| <%= msg["msg"] %> <%= Enum.map msg["params"], fn(param) -> %><%= param %> <% end %>
<% end %>
    """
  end
end
