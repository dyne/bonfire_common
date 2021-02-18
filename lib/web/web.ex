defmodule Bonfire.Web do
  @moduledoc false

  alias Bonfire.Common.Utils

  def controller(opts \\ []) do
    # IO.inspect(controller: opts)

    opts =
      opts
      |> Keyword.put_new(:namespace, Bonfire.Web)
    quote do
      use Phoenix.Controller, unquote(opts)
      require Logger
      import Plug.Conn
      import Bonfire.Common.Web.Gettext
      alias Bonfire.Web.Router.Helpers, as: Routes
      alias Bonfire.Web.Plugs.{MustBeGuest, MustLogIn}
      import Phoenix.LiveView.Controller
      import Bonfire.Common.Utils

      unquote(Utils.use_if_available(Thesis.Controller))

    end
  end

  def view(opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:root, "lib/web/views")
      |> Keyword.put_new(:namespace, Bonfire.Web)
    quote do
      use Phoenix.View, unquote(opts)
      require Logger
      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      unquote(view_helpers())

    end
  end

  def live_view(opts \\ []) do
    # IO.inspect(live_view: opts)
    opts =
      opts
      |> Keyword.put_new(:layout, {Bonfire.Common.Config.get!(:default_layout_module), "live.html"})
      |> Keyword.put_new(:namespace, Bonfire.Web)
    quote do
      use Phoenix.LiveView, unquote(opts)
      require Logger

      unquote(view_helpers())

    end
  end

  def live_component(opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:namespace, Bonfire.Web)
    quote do
      use Phoenix.LiveComponent, unquote(opts)
      require Logger
      unquote(view_helpers())

    end
  end

  def plug(_opts \\ []) do
    quote do
      alias Bonfire.Web.Router.Helpers, as: Routes
      import Plug.Conn
      import Phoenix.Controller
      require Logger
    end
  end

  def live_plug(_opts \\ []) do
    quote do
      alias Bonfire.Web.Router.Helpers, as: Routes
      import Phoenix.LiveView
      require Logger
    end
  end

  def router(opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:namespace, Bonfire.Web)
    quote do
      use Phoenix.Router, unquote(opts)
      require Logger

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router

      import Bonfire.Common.Utils

      unquote(Utils.use_if_available(Thesis.Router))

    end
  end

  def channel(opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:namespace, Bonfire.Web)
    quote do
      use Phoenix.Channel, unquote(opts)
      require Logger

      import Bonfire.Common.Web.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import Bonfire.Common.Web.ErrorHelpers
      import Bonfire.Common.Web.Gettext

      alias Bonfire.Web.Router.Helpers, as: Routes

      alias Bonfire.Common.Utils
      import Bonfire.Common.Utils

      unquote(Utils.use_if_available(Thesis.View, Bonfire.Common.Web.ContentAreas))

    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__({which, opts}) when is_atom(which) and is_list(opts) do
    apply(__MODULE__, which, [opts])
  end
end
