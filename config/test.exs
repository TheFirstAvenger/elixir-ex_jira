use Mix.Config

config :jirex,
  account: "test_account",
  username: "test_username",
  password: "test_password",
  http_client: Jirex.MockClient

config :logger,
  level: :warn
