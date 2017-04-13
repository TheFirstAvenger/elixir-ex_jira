use Mix.Config

config :ex_jira,
  account: "test_account",
  username: "test_username",
  password: "test_password",
  http_client: ExJira.MockClient

config :logger,
  level: :warn
