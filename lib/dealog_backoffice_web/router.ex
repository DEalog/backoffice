defmodule DealogBackofficeWeb.Router do
  use DealogBackofficeWeb, :router

  import DealogBackofficeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DealogBackofficeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :preview do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DealogBackofficeWeb.LayoutView, :preview}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :user_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  ## Authentication routes

  scope "/", DealogBackofficeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create

    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create

    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", DealogBackofficeWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live("/", DashboardLive, :index)

    scope "/all-messages", AllMessagesLive do
      live("/", Index, :index, as: :all_messages)
      live("/:id", Show, :show, as: :all_messages)
    end

    scope "/organization-messages", OrganizationMessagesLive do
      live("/", Index, :index, as: :organization_messages)
      live("/new", Edit, :new, as: :organization_messages)
      live("/:id/change", Edit, :change, as: :organization_messages)
      live("/:id/send_for_approval", Edit, :send_for_approval, as: :organization_messages)
      live("/:id/delete", Edit, :delete, as: :organization_messages)
      live("/:id/archive", Edit, :archive, as: :organization_messages)
      live("/:id/discard_change", Edit, :discard_change, as: :organization_messages)
      live("/:id", Show, :show, as: :organization_messages)
    end

    scope "/approvals", MessageApprovalsLive do
      live("/", Index, :index, as: :approvals)
      live("/:id", Show, :show, as: :approvals)
      live "/:id/approve", Edit, :approve, as: :approvals
      live "/:id/reject", Edit, :reject, as: :approvals
      live "/:id/publish", Edit, :publish, as: :approvals
    end

    scope "/my-account", MyAccountLive do
      live("/", Index, :index, as: :my_account)
    end

    scope "/settings", SettingsLive do
      live("/", Index, :index, as: :settings)

      scope "/accounts", Accounts do
        live("/new/:user_id", Edit, :new, as: :settings)
        live("/:account_id/change", Edit, :change, as: :settings)
      end
    end

    live("/changelog", ChangelogLive, :index)
    live("/readme", ReadmeLive, :index)
    live("/design-system", DesignSystemLive, :index)
  end

  scope "/", DealogBackofficeWeb do
    pipe_through [:user_api]

    post "/api/users/relogin", UserApiController, :relogin_after_password_change
  end

  scope "/", DealogBackofficeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/_preview", DealogBackofficeWeb do
    pipe_through [:preview, :require_authenticated_user]

    live("/", PreviewLive)
  end

  scope "/health", DealogBackofficeWeb do
    get "/", HealthController, :check
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
  if Mix.env() in [:dev] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/system", metrics: DealogBackofficeWeb.Telemetry
    end
  end
end
