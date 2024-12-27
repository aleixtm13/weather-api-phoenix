defmodule WeatherApiWeb.GeocodingController do
  use WeatherApiWeb, :controller

  alias WeatherApiWeb.Geocoding.GeocodingService

  def show(conn, %{"city" => city}) do
    case GeocodingService.get_coordinates(city) do
      {:ok, coordinates} ->
        json(conn, %{city: city, lat: coordinates.lat, lon: coordinates.lon})
      {:error, reason} ->
        json(conn, %{error: reason})
    end
  end
end
