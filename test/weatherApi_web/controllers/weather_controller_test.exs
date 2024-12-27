defmodule WeatherApiWeb.WeatherControllerTest do
  use WeatherApiWeb.ConnCase

  import WeatherApi.WeathersFixtures

  alias WeatherApi.Weathers.Weather

  @create_attrs %{
    long: "120.5",
    lat: "120.5"
  }
  @update_attrs %{
    long: "456.7",
    lat: "456.7"
  }
  @invalid_attrs %{long: nil, lat: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all weathers", %{conn: conn} do
      conn = get(conn, ~p"/api/weathers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create weather" do
    test "renders weather when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/weathers", weather: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/weathers/#{id}")

      assert %{
               "id" => ^id,
               "lat" => "120.5",
               "long" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/weathers", weather: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update weather" do
    setup [:create_weather]

    test "renders weather when data is valid", %{conn: conn, weather: %Weather{id: id} = weather} do
      conn = put(conn, ~p"/api/weathers/#{weather}", weather: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/weathers/#{id}")

      assert %{
               "id" => ^id,
               "lat" => "456.7",
               "long" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, weather: weather} do
      conn = put(conn, ~p"/api/weathers/#{weather}", weather: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete weather" do
    setup [:create_weather]

    test "deletes chosen weather", %{conn: conn, weather: weather} do
      conn = delete(conn, ~p"/api/weathers/#{weather}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/weathers/#{weather}")
      end
    end
  end

  defp create_weather(_) do
    weather = weather_fixture()
    %{weather: weather}
  end
end
