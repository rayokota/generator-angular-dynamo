defmodule Repo.Migrations.Create<%= _.capitalize(pluralize(name)) %> do
  use Ecto.Migration

  def up do
    "CREATE TABLE <%= pluralize(name) %>(
      <% _.each(attrs, function (attr) { %>
      <%= attr.attrName %> <%= attr.attrImplType %><% if (attr.attrType == 'Enum' || attr.attrType == 'String' || attr.attrType == 'Date') { if (attr.maxLength) { %>(<%= attr.maxLength %>)<% } else { %>(255)<% }} %>, <%}); %>
      id SERIAL
     )"
  end

  def down do
    "DROP TABLE <%= pluralize(name) %>"
  end
end
