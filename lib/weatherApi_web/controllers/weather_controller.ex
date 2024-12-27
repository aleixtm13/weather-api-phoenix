defmodule WeatherApiWeb.WeatherController do
  use WeatherApiWeb, :controller

  alias WeatherApi.WeatherService

  def show(conn, %{"city" => city}) do
    case WeatherService.get_weather(city) do
      {:ok, weather} ->
        json(conn, %{city: city, weather: weather})
      {:error, reason} ->
        json(conn, %{error: reason})
    end
  end

end
