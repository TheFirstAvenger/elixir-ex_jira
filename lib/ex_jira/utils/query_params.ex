defmodule ExJira.QueryParams do
  @moduledoc """
  Helper module to convert parameters passed as a keyword list into a querystring.
  """

  @doc """
  Converts a keyword list and a list of atoms into a querystring containing only
  entries that exist in both the keyword list and the list of atoms.

  ## Examples

      iex> ExJira.QueryParams.convert([asdf: 123, hjkl: 456], [:asdf, :hjkl])
      "asdf=123&hjkl=456"

      iex> ExJira.QueryParams.convert([asdf: 123, hjkl: 456], [:asdf])
      "asdf=123"

      iex> ExJira.QueryParams.convert([asdf: 123, hjkl: 456], [:hjkl])
      "hjkl=456"

      iex> ExJira.QueryParams.convert([asdf: 123, hjkl: 456], [:qwerty])
      ""

      iex> ExJira.QueryParams.convert([asdf: 123, hjkl: 456], [])
      ""

  """
  @spec convert([{atom, String.t()}], [atom]) :: String.t()
  def convert(_params, []), do: ""

  def convert(params, [h | t]) do
    amp =
      case t do
        [] -> ""
        _ -> "&"
      end

    if Keyword.has_key?(params, h) do
      "#{to_string(h)}=#{params[h]}#{amp}#{convert(params, t)}"
    else
      convert(params, t)
    end
  end
end
