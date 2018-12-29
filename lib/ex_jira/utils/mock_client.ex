defmodule ExJira.MockClient do
  @moduledoc """
  Mock Client for use in testing. Theory behind this approach to mocks explained by José Valim [here](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/).
  """

  @headers %HTTPotion.Headers{hdrs: %{"content-type" => "application/json;charset=UTF-8"}}

  # Request
  def get("https://test_account/rest/api/latest/headers/test?a=b&c=d",
        timeout: 30000,
        headers: [
          "Content-Type": "application/json",
          Authorization: "Basic dGVzdF91c2VybmFtZTp0ZXN0X3Bhc3N3b3Jk"
        ]
      ) do
    %HTTPotion.Response{body: "{\"id\":\"1000\"}", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/headers/test2?a=b&c=d",
        timeout: 30000,
        headers: [
          "Content-Type": "application/json",
          Authorization: "Basic dGVzdF91c2VybmFtZTp0ZXN0X3Bhc3N3b3Jk"
        ]
      ) do
    %HTTPotion.Response{
      body: "{\"total\":2, \"things\":[{\"id\":\"1004\"},{\"id\":\"1005\"}]}",
      headers: @headers
    }
  end

  def get("https://test_account/rest/api/latest/some/item?a=b&c=d", _) do
    %HTTPotion.Response{body: "{\"id\":\"1001\"}", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/httpotion/failure?a=b&c=d", _) do
    %HTTPotion.ErrorResponse{message: "some error"}
  end

  def get("https://test_account/rest/api/latest/some/items?a=b&c=d", _) do
    %HTTPotion.Response{
      body: "{\"total\":2, \"items\":[{\"id\":\"1002\"},{\"id\":\"1003\"}]}",
      headers: @headers
    }
  end

  def get("https://test_account/rest/api/latest/some/failure?a=b&c=d", _) do
    %HTTPotion.ErrorResponse{message: "aliens"}
  end

  def get("https://test_account/rest/api/latest/one/widget?c=d&e=f", _) do
    %HTTPotion.Response{body: "{\"id\":\"1006\"}", headers: @headers}
  end

  # Dashboard

  def get("https://test_account/rest/api/latest/dashboard", _) do
    %HTTPotion.Response{
      body: "{\"total\":2, \"dashboards\":[{\"id\":\"1007\"},{\"id\":\"1008\"}]}",
      headers: @headers
    }
  end

  def get("https://test_account/rest/api/latest/dashboard/1009", _) do
    %HTTPotion.Response{body: "{\"id\":\"1009\"}", headers: @headers}
  end

  # Project

  def get("https://test_account/rest/api/latest/project", _) do
    %HTTPotion.Response{body: "[{\"id\":\"1010\"},{\"id\":\"1011\"}]", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/issue/ISSUE-1012", _) do
    %HTTPotion.Response{body: "{\"id\":\"1012\"}", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/issue/ISSUE-1012?expand=lead,url,description", _) do
    %HTTPotion.Response{body: "{\"id\":\"1012\"}", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/project/1012", _) do
    %HTTPotion.Response{body: "{\"id\":\"1012\"}", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/project/1012?expand=lead,url,description", _) do
    %HTTPotion.Response{body: "{\"id\":\"1012\"}", headers: @headers}
  end

  def get("https://test_account/rest/api/latest/search?jql=project=1013", _) do
    %HTTPotion.Response{
      body: "{\"total\":2, \"issues\":[{\"id\":\"100040\"}, {\"id\":\"100041\"}]}",
      headers: @headers
    }
  end

  def get("https://test_account/rest/api/latest/search?expand=operations&jql=project=1013", _) do
    %HTTPotion.Response{
      body: "{\"total\":2, \"issues\":[{\"id\":\"100040\"}, {\"id\":\"100041\"}]}",
      headers: @headers
    }
  end
end
