use Mix.Config

config :jirex,
  account: System.get_env("JIRA_ACCOUNT"),
  username: System.get_env("JIRA_USERNAME"),
  password: System.get_env("JIRA_PASSWORD")
