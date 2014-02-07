defmodule <%= _.capitalize(pluralize(name)) %>Router do
  use Dynamo.Router

  get "/" do
    conn.resp 200, ExJSON.generate <%= _.capitalize(name) %>Queries.all
  end

  get "/:id" do
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    conn.resp 200, ExJSON.generate <%= name %>
  end

  post "/" do
    json = ExJSON.parse conn.resp_body
    <%= name %> = <%= _.capitalize(name) %>.new(
      <% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: json["<%= attr.attrName %>"]<% delim = ', '; }); %>
    )
    Repo.create(<%= name %>)
    conn.resp 201, ExJSON.generate <%= name %>
  end

  put "/:id" do
    json = ExJSON.parse conn.resp_body
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id).update(json)
    conn.resp 200, ExJSON.generate <%= name %>
  end

  delete "/:id" do
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    Repo.delete(<%= name %>)
    conn.resp 200, ""
  end
end
