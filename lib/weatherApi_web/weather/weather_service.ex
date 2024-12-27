defmodule WeatherApi.WeatherService do
  @api_url "https://api.openweathermap.org/data/2.5/weather"
  @api_key System.get_env("OPENWEATHER_API_KEY")

  def get_weather(city) do
    url = "#{@api_url}?q=#{city}&appid=#{@api_key}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "City not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
