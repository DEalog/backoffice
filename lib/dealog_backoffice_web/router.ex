defmodule DealogBackofficeWeb.Router do
  use DealogBackofficeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DealogBackofficeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :preview do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DealogBackofficeWeb.LayoutView, :preview}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DealogBackofficeWeb do
    pipe_through :browser

    live("/", DashboardLive, :index)
    live("/all-messages", AllMessagesLive, :index)

    scope "/organization-messages" do
      live("/", OrganizationMessagesLive.Index, :index, as: :organization_messages)

      live("/new", OrganizationMessagesLive.Edit, :new, as: :organization_messages)

      live("/:id/change", OrganizationMessagesLive.Edit, :change, as: :organization_messages)

      live(
        "/:id/send_for_approval",
        OrganizationMessagesLive.Edit,
        :send_for_approval,
        as: :organization_messages
      )

      live("/:id/delete", OrganizationMessagesLive.Edit, :delete, as: :organization_messages)
      live("/:id", OrganizationMessagesLive.Show, :show, as: :organization_messages)
    end

    scope "/approvals" do
      live("/", MessageApprovalsLive.Index, :index, as: :approvals)
      live "/:id/approve", MessageApprovalsLive.Edit, :approve, as: :approvals
      live "/:id/reject", MessageApprovalsLive.Edit, :reject, as: :approvals
      live("/:id", MessageApprovalsLive.Show, :show, as: :approvals)
    end

    live("/changelog", ChangelogLive, :index)
    live("/my-account", MyAccountLive, :index)
    live("/settings", SettingsLive, :index)
    live("/readme", ReadmeLive, :index)
    live("/design-system", DesignSystemLive, :index)
  end

  scope "/_preview", DealogBackofficeWeb do
    pipe_through :preview

    live("/", PreviewLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", DealogBackofficeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/system", metrics: DealogBackofficeWeb.Telemetry
    end
  end
end
