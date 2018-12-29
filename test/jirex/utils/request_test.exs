defmodule RequestTest do
  use ExUnit.Case
  alias ExJira.Request

  doctest Request

  test "request headers" do
    assert Request.request("GET", "/headers/test", "a=b&c=d", "") == {:ok, %{"id" => "1000"}}
  end

  test "get headers" do
    assert Request.get_all("/headers/test2", "things", "a=b&c=d") ==
             {:ok, [%{"id" => "1004"}, %{"id" => "1005"}]}
  end
end
