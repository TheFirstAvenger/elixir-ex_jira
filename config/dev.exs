use Mix.Config

config :ex_jira,
  account: System.get_env("JIRA_ACCOUNT"),
  username: System.get_env("JIRA_USERNAME"),
  password: System.get_env("JIRA_PASSWORD")
