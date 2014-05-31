defmodule <%= _.capitalize(baseName) %>.Dynamo do
  use Dynamo

  config :server, port: 3000

  config :dynamo,
    endpoint: ApplicationRouter,
    static_route: "/public"

  templates do
    use Dynamo.Helpers
  end
end

defmodule <%= _.capitalize(baseName) %> do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    <%= _.capitalize(baseName) %>.Sup.start_link
  end
end

defmodule <%= _.capitalize(baseName) %>.Sup do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link({ :local, __MODULE__ }, __MODULE__, [])
  end

  def init([]) do
    tree = [ worker(<%= _.capitalize(baseName) %>.Dynamo, []), worker(Repo, []) ]
    supervise(tree, strategy: :one_for_all)
  end
end

defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do 
    parse_url "ecto://<%= username %><% if (password) { %>:<%= password %><% }; %>@localhost/dynamo_db"
  end

  def priv do
    app_dir(:<%= baseName %>, "priv/repo")
  end
end

<% _.each(entities, function (entity) { %>
defmodule <%= _.capitalize(entity.name) %> do
  use Ecto.Model

  schema "<%= pluralize(entity.name) %>" do
    <% _.each(entity.attrs, function (attr) { %>
    field :<%= attr.attrName %>, :<% if (attr.attrType == 'Enum' || attr.attrType == 'Date') { %>string<% } else { %><%= attr.attrType.toLowerCase() %><% }}); %>
  end
end

defmodule <%= _.capitalize(entity.name) %>Queries do
  import Ecto.Query

  def all do
    Enum.map(_all, fn(x) -> x.__struct__.__schema__(:keywords, x) end)
  end

  defp _all do
    query = from x in <%= _.capitalize(entity.name) %>,
            order_by: x.id,
            select: x
    Repo.all(query)
  end
end
<% }); %>
