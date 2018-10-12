require Logger

defmodule ExJira.Request do
  @moduledoc """
  Provides the base request function and helper functions for GET and POST.
  All request functions return either {:ok, data} or {:error, reason}
  """

  @type request_response :: {:ok, any} | {:error, any}

  @spec jira_account() :: String.t()
  defp jira_account(), do: Application.get_env(:ex_jira, :account)
  @spec jira_username() :: String.t()
  defp jira_username(), do: Application.get_env(:ex_jira, :username)
  @spec jira_password() :: String.t()
  defp jira_password(), do: Application.get_env(:ex_jira, :password)
  @spec jira_timeout() :: String.t()
  defp jira_timeout(), do: Application.get_env(:ex_jira, :timeout) || 30_000
  @spec jira_client() :: atom
  defp jira_client(), do: Application.get_env(:ex_jira, :http_client) || HTTPotion

  @doc """
  Sends a GET request to the specified resource_path with the specified query_params,
  returning the subitem with the key specified by the resource parameter. Sends
  multiple requests if more resources are available.

  Note: REST endpoints that return all entries every time as a top level list
  and never page (e.g. Project) should use `get_one/2` instead.

  ## Examples

      iex> Request.get_all("/some/items", "items", "a=b&c=d")
      {:ok, [%{"id" => "1002"},%{"id" => "1003"}]}

      iex> Request.get_all("/some/failure", "items", "a=b&c=d")
      {:error, "aliens"}

  """
  @spec get_all(String.t(), String.t(), String.t()) :: request_response
  def get_all(resource_path, resource, query_params) do
    request("GET", resource_path, query_params, "")
    |> get_more([], resource_path, resource, query_params)
  end

  @doc """
  Sends a GET request to the specified resource_path with the specified query_params.
  Expects a single return item.

      iex> Request.get_one("/one/widget", "c=d&e=f")
      {:ok, %{"id" => "1006"}}

  """
  @spec get_one(String.t(), String.t()) :: request_response
  def get_one(resource_path, query_params) do
    request("GET", resource_path, query_params, "")
  end

  @spec get_more(request_response, [any], String.t(), String.t(), String.t()) :: request_response
  defp get_more({:error, reason}, _, _, _, _), do: {:error, reason}

  defp get_more(
         {:ok, %{"next" => next_req} = response},
         prev_items,
         resource_path,
         resource,
         query_params
       ) do
    items = response[resource]

    [eq: _, ins: request_path] =
      String.myers_difference("https://#{jira_account()}/rest/api/latest", next_req)

    request("GET", request_path, "", "")
    |> get_more(prev_items ++ items, resource_path, resource, query_params)
  end

  defp get_more({:ok, response}, prev_items, _, resource, _) do
    items = response[resource]
    {:ok, prev_items ++ items}
  end

  @doc """
  Sends a POST request to the specified resource_path with the specified
  query_params (as a string in the form "key1=val1&key2=val2") and the
  specified payload.
  """
  @spec post(String.t(), String.t(), String.t()) :: request_response
  def post(resource_path, query_params, payload) do
    request("POST", resource_path, query_params, payload)
  end

  @doc """
  Sends a request using the specified method to the specified resource_path
  with the specified query_params (as a string in the form "key1=val1&key2=val2")
  and the specified payload.

  ## Examples

      iex> ExJira.Request.request("GET", "/some/item", "a=b&c=d", "")
      {:ok, %{"id" => "1001"}}

      iex> ExJira.Request.request("GET", "/httpotion/failure", "a=b&c=d", "")
      {:error, "some error"}

  """
  @spec request(String.t(), String.t(), String.t(), String.t()) :: request_response
  def request(method, resource_path, query_params, payload) do
    url = {resource_path, query_params} |> build_request_url
    auth = get_auth()

    Logger.debug("ExJira.Request: Sending #{method} to #{url} using #{jira_client()}")

    case httpotion_request(jira_client(), method, url, payload,
           timeout: jira_timeout(),
           headers: ["Content-Type": "application/json", Authorization: auth]
         ) do
      %HTTPotion.ErrorResponse{message: message} ->
        {:error, message}

      %HTTPotion.Response{status_code: 404} ->
        {:error, "404 - Not Found"}

      %HTTPotion.Response{
        body: body,
        headers: %{hdrs: %{"content-type" => "application/json;charset=UTF-8"}}
      } ->
        Poison.decode(body)

      %HTTPotion.Response{headers: %{hdrs: %{"content-type" => content_type}}} ->
        {:error, "Invalid content-type returned: #{content_type}"}
    end
  end

  defp build_request_url({resource_path, ""}) do
    "https://#{jira_account()}/rest/api/latest#{resource_path}"
  end

  defp build_request_url({resource_path, query_params}) do
    params = query_params |> String.trim_trailing("&")
    "https://#{jira_account()}/rest/api/latest#{resource_path}?#{params}"
  end

  defp get_auth() do
    auth = "#{jira_username()}:#{jira_password()}" |> Base.encode64()
    "Basic #{auth}"
  end

  @spec httpotion_request(atom, String.t(), String.t(), String.t(), list) ::
          %HTTPotion.ErrorResponse{} | %HTTPotion.Response{}
  defp httpotion_request(client, "GET", url, _payload, opts), do: client.get(url, opts)

  defp httpotion_request(client, "POST", url, payload, opts),
    do: client.post(url, [body: payload] ++ opts)
end
