defmodule ApplicationRouter do
  use Dynamo.Router
  import Dynamo.HTTP.Redirect

  get "/" do
    redirect conn, to: "/public/index.html"
  end

  <% _.each(entities, function (entity) { %>
  forward "/<%= baseName %>/<%= pluralize(entity.name) %>", to: <%= _.capitalize(pluralize(entity.name)) %>Router<% }); %>

end
