defmodule <%= _.capitalize(pluralize(name)) %>Router do
  use Dynamo.Router

  get "/" do
    conn.resp 200, ExJSON.generate <%= _.capitalize(name) %>Queries.all
  end

  get "/:id" do
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    if <%= name %> do
      conn.resp 200, ExJSON.generate <%= name %>.__struct__.__schema__(:keywords, <%= name %>)
    else 
      conn.resp 404, ""
    end
  end

  post "/" do
    conn = conn.fetch :body
    json = ExJSON.parse(conn.req_body, :to_map)
    <%= name %> = %<%= _.capitalize(name) %>{
      <% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: json["<%= attr.attrName %>"]<% delim = ', '; }); %>
    }
    <%= name %> = Repo.insert(<%= name %>)
    conn.resp 201, ExJSON.generate <%= name %>.__struct__.__schema__(:keywords, <%= name %>)
  end

  put "/:id" do
    conn = conn.fetch :body
    json = ExJSON.parse(conn.req_body, :to_map)
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    if <%= name %> do
      <%= name %> = %{<%= name %> | <% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: json["<%= attr.attrName %>"]<% delim = ', '; }); %>}
      Repo.update(<%= name %>)
      conn.resp 200, ExJSON.generate <%= name %>.__struct__.__schema__(:keywords, <%= name %>)
    else 
      conn.resp 404, ""
    end
  end

  delete "/:id" do
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    if <%= name %> do
      Repo.delete(<%= name %>)
      conn.resp 204, ""
    else 
      conn.resp 404, ""
    end
  end
end
