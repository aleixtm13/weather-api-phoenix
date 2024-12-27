defmodule WeatherApiWeb.Geocoding.GeocodingService do
  @api_url "http://api.openweathermap.org/geo/1.0/direct"
  @api_key System.get_env("OPENWEATHER_API_KEY")

  def get_coordinates(city) do
    url = "#{@api_url}?q=#{city}&limit=1&appid=#{@api_key}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(Jason.decode!(body))
        case Jason.decode!(body) do
          [%{
            "country" => _,
            "lat" => lat,
            "local_names" => _,
            "lon" => lon,
            "name" => _,
            "state" => _
          }] ->
            {:ok, %{lat: lat, lon: lon}}

          _ ->
            {:error, "Invalid response format"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "City not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
