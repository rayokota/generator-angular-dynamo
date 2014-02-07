defmodule <%= _.capitalize(baseName) %>.Mixfile do
  use Mix.Project

  def project do
    [ app: :<%= baseName %>,
      version: "0.0.1",
      dynamos: [<%= _.capitalize(baseName) %>.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/<%= baseName %>/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { <%= _.capitalize(baseName) %>, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "elixir-lang/dynamo" },
      { :postgrex, github: "ericmj/postgrex" },
      { :ecto, github: "elixir-lang/ecto"},
      { :exjson, github: "guedes/exjson"}]
  end
end
