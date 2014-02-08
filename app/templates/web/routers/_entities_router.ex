defmodule <%= _.capitalize(pluralize(name)) %>Router do
  use Dynamo.Router

  get "/" do
    conn.resp 200, ExJSON.generate <%= _.capitalize(name) %>Queries.all
  end

  get "/:id" do
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    if <%= name %> do
      conn.resp 200, ExJSON.generate <%= name %>.__entity__(:keywords)
    else 
      conn.resp 404, ""
    end
  end

  post "/" do
    conn = conn.fetch :body
    json = ExJSON.parse conn.req_body
    <%= name %> = <%= _.capitalize(name) %>.new(
      <% var delim = ''; _.each(attrs, function (attr) { %><%= delim %><%= attr.attrName %>: json["<%= attr.attrName %>"]<% delim = ', '; }); %>
    )
    <%= name %> = Repo.create(<%= name %>)
    conn.resp 201, ExJSON.generate <%= name %>.__entity__(:keywords)
  end

  put "/:id" do
    conn = conn.fetch :body
    json = ExJSON.parse conn.req_body
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    if <%= name %> do
      <%= name %> = <%= name %>.update(json)
      Repo.update(<%= name %>)
      conn.resp 200, ExJSON.generate <%= name %>.__entity__(:keywords)
    else 
      conn.resp 404, ""
    end
  end

  delete "/:id" do
    <%= name %> = Repo.get(<%= _.capitalize(name) %>, id)
    if <%= name %> do
      Repo.delete(<%= name %>)
      conn.resp 200, ""
    else 
      conn.resp 404, ""
    end
  end
end
