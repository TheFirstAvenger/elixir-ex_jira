# ExJira

Elixir wrapper for the JIRA REST API as outlined [here](https://docs.atlassian.com/jira/REST/cloud/).

Still in development. POST has not been tested. Need remainder of resources implemented. Contributions welcome!

## Installation

ExJira can be installed by adding `ex_jira` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_jira, "~> 0.0.1"}]
end
```

## Configuration

ExJira requires three application variables. Add the following variables to your config.exs file (this example retrieves those variables from environment variables):

```elixir
config :ex_jira,
  account: System.get_env("JIRA_ACCOUNT"),
  username: System.get_env("JIRA_USERNAME"),
  password: System.get_env("JIRA_PASSWORD")
```

The HTTPotion timeout value is configurable by the optional `timeout` application variable, which defaults to 30_000 (30 seconds) when not set:

```elixir
config :ex_jira,
  timeout: 60_000
```

For testing purposes, you can override the HTTP client that ExJira uses via the following application variable:
```elixir
config :ex_jira,
  http_client: ExJira.MockClient
```

## Usage

### Dashboard
```elixir
{:ok, dashboards} = ExJira.Dashboard.all()
{:ok, dashboards} = ExJira.Dashboard.all(filter: "favourite")
dashboards = ExJira.Dashboard.all!()
dashboards = ExJira.Dashboard.all!(filter: "favourite")
```
Raw requests to Jira for resources that are not yet implemented can be made like this:

```elixir
{:ok, dashboards} = ExJira.Request.get("/dashboard","filter=favourite")
{:ok, ret} = ExJira.Request.post("/project", "", "{\"name\":\"test\"}")
```

Docs can be found at [https://hexdocs.pm/ex_jira](https://hexdocs.pm/ex_jira).
