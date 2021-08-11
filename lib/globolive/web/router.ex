defmodule Globolive.Web.Router do
  use Globolive.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Globolive.Web do
    pipe_through :api

    post "/v1/checkin", CheckinController, :create
  end
end
