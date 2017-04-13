# Jirex

Elixir wrapper for the JIRA REST API as outlined (here)[https://docs.atlassian.com/jira/REST/cloud/].

Still in development. POST has not been tested. Need remainder of resources implemented. Contributions welcome!

## Installation

Jirex can be installed by adding `jirex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:jirex, "~> 0.0.1"}]
end
```

## Configuration

Jirex requires three application variables. Add the following variables to your config.exs file (this example retrieves those variables from environment variables):

```elixir
config :jirex,
  account: System.get_env("JIRA_ACCOUNT"),
  username: System.get_env("JIRA_USERNAME"),
  password: System.get_env("JIRA_PASSWORD")
```

The HTTPotion timeout value is configurable by the optional `timeout` application variable, which defaults to 30_000 (30 seconds) when not set:

```elixir
config :jirex,
  timeout: 60_000
```

For testing purposes, you can override the HTTP client that Jirex uses via the following application variable:
```elixir
config :jirex,
  http_client: Jirex.MockClient
```

## Usage

### Dashboard
```elixir
{:ok, dashboards} = Jirex.Dashboard.all()
{:ok, dashboards} = Jirex.Dashboard.all(filter: "favourite")
dashboards = Jirex.Dashboard.all!()
dashboards = Jirex.Dashboard.all!(filter: "favourite")
```
Raw requests to Jira for resources that are not yet implemented can be made like this:

```elixir
{:ok, dashboards} = Jirex.Request.get("/dashboard","filter=favourite")
{:ok, ret} = Jirex.Request.post("/project", "", "{\"name\":\"test\"}")
```

Docs can be found at [https://hexdocs.pm/jirex](https://hexdocs.pm/jirex).
