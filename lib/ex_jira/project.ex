defmodule ExJira.Project do
  alias ExJira.Request
  alias ExJira.QueryParams

  @moduledoc """
  Provides access to the Project resource.
  """

  @all_params [:expand, :recent]
  @get_params [:expand]
  @get_issues_params [:fields, :expand, :properties]

  @doc """
  Returns all projects. Request parameters as described [here](https://docs.atlassian.com/jira/REST/cloud/#api/2/project-getAllProjects)

  ## Examples

      iex> ExJira.Project.all()
      {:ok, [%{"id" => "1010"}, %{"id" => "1011"}]}

  """
  @spec all([{atom, String.t}]) :: Request.request_response
  def all(query_params \\ []) do
    Request.get_one("/project", QueryParams.convert(query_params, @all_params))
  end

  @doc """
  Same as `all/1` but raises error if it fails

  ## Examples

      iex> ExJira.Project.all!()
      [%{"id" => "1010"}, %{"id" => "1011"}]

  """
  @spec all!([{atom, String.t}]) :: [any]
  def all!(query_params \\ []) do
    case all(query_params) do
      {:ok, items} -> items
      {:error, reason} -> raise "Error in #{__MODULE__}.all!: #{inspect reason}"
    end
  end

  @doc """
  Returns the specified project as described [here](https://docs.atlassian.com/jira/REST/cloud/#api/2/project-getProject).

  ## Examples

      iex> ExJira.Project.get("1012")
      {:ok, %{"id" => "1012"}}

      iex> ExJira.Project.get("1012", expand: "lead,url,description")
      {:ok, %{"id" => "1012"}}

  """
  @spec get(String.t, [{atom, String.t}]) :: Request.request_response
  def get(id, query_params \\ []) do
    Request.get_one("/project/#{id}", QueryParams.convert(query_params, @get_params))
  end

  @doc """
  Same as `get/1` but raises error if it fails

  ## Examples

      iex> ExJira.Project.get!("1012")
      %{"id" => "1012"}

      iex> ExJira.Project.get!("1012", expand: "lead,url,description")
      %{"id" => "1012"}

  """
  @spec get!(String.t, [{atom, String.t}]) :: any
  def get!(id, query_params \\ []) do
    case get(id, query_params) do
      {:ok, item} -> item
      {:error, reason} -> raise "Error in #{__MODULE__}.get!: #{inspect reason}"
    end
  end


  @doc """
  Returns the issues for the specified project.

  ## Examples

      iex> ExJira.Project.get_issues("1013")
      {:ok, [%{"id" => "100040"}, %{"id" => "100041"}]}

      iex> ExJira.Project.get_issues("1013", expand: "operations")
      {:ok, [%{"id" => "100040"}, %{"id" => "100041"}]}

  """
  @spec get_issues(String.t, [{atom, String.t}]) :: Request.request_response
  def get_issues(id, query_params \\ []) do
    Request.get_all("/search", "issues", "#{QueryParams.convert(query_params, @get_issues_params)}jql=project=#{id}")
  end

  @doc """
  Same as `get/1` but raises error if it fails

  ## Examples

      iex> ExJira.Project.get_issues!("1013")
      [%{"id" => "100040"}, %{"id" => "100041"}]

      iex> ExJira.Project.get_issues!("1013", expand: "operations")
      [%{"id" => "100040"}, %{"id" => "100041"}]

  """
  @spec get_issues!(String.t, [{atom, String.t}]) :: any
  def get_issues!(id, query_params \\ []) do
    case get_issues(id, query_params) do
      {:ok, items} -> items
      {:error, reason} -> raise "Error in #{__MODULE__}.get_issues!: #{inspect reason}"
    end
  end

  @doc """
  Returns a single issue based on specified ticket number.

  ## Examples

  iex> ExJira.Project.get_issue("ISSUE-1012")
  {:ok, %{"id" => "1012"}}

  iex> ExJira.Project.get_issue("ISSUE-1012", expand: "lead,url,description")
  {:ok, %{"id" => "1012"}}

  """
  @spec get_issue(String.t, [{atom, String.t}]) :: Request.request_response
  def get_issue(id, query_params \\ []) do
    Request.get_one("/issue/#{id}", QueryParams.convert(query_params, @get_params))
  end
end
