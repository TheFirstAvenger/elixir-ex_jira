defmodule ExJira.Dashboard do
  alias ExJira.QueryParams
  alias ExJira.Request

  @moduledoc """
  Provides access to the Dashboard resource.
  """

  @all_params [:filter, :startAt, :maxResults]

  @doc """
  Returns all dashboards. Request parameters as described [here](https://docs.atlassian.com/jira/REST/cloud/#api/2/dashboard-list)

  ## Examples

      iex> ExJira.Dashboard.all()
      {:ok, [%{"id" => "1007"}, %{"id" => "1008"}]}

  """
  @spec all([{atom, String.t()}]) :: Request.request_response()
  def all(query_params \\ []) do
    Request.get_all("/dashboard", "dashboards", QueryParams.convert(query_params, @all_params))
  end

  @doc """
  Same as `all/1` but raises error if it fails

  ## Examples

      iex> ExJira.Dashboard.all!()
      [%{"id" => "1007"}, %{"id" => "1008"}]

  """
  @spec all!([{atom, String.t()}]) :: [any]
  def all!(query_params \\ []) do
    case all(query_params) do
      {:ok, items} -> items
      {:error, reason} -> raise "Error in #{__MODULE__}.all!: #{inspect(reason)}"
    end
  end

  @doc """
  Returns the specified dashboard as described [here](https://docs.atlassian.com/jira/REST/cloud/#api/2/dashboard-getDashboard).

  ## Examples

      iex> ExJira.Dashboard.get("1009")
      {:ok, %{"id" => "1009"}}

  """
  @spec get(String.t()) :: Request.request_response()
  def get(id) do
    Request.get_one("/dashboard/#{id}", "")
  end

  @doc """
  Same as `get/1` but raises error if it fails

  ## Examples

      iex> ExJira.Dashboard.get!("1009")
      %{"id" => "1009"}

  """
  @spec get!(String.t()) :: any
  def get!(id) do
    case get(id) do
      {:ok, item} -> item
      {:error, reason} -> raise "Error in #{__MODULE__}.get!: #{inspect(reason)}"
    end
  end
end
