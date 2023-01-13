defmodule Caterpillar do
  @dir "files"
  def get_site(url) do
    :get
    |> Finch.build(url)
    |> Finch.request(DefaultFinch)
    |> case do
      {:ok, %{status: 200, body: body, headers: headers}} ->
        content_type =
          headers
          |> Map.new()
          |> Map.get("content-type", nil)

        if content_type == "text/html" do
          save_url(url, body)
        end

      error ->
        raise "failed #{inspect(error)}"
    end
  end

  def save_url(url, body) do
    File.mkdir_p!(@dir)
    hash = :crypto.hash(:sha256, url) |> Base.encode16() |> String.downcase()
    File.write!(Path.join(@dir, hash), body)
  end
end
