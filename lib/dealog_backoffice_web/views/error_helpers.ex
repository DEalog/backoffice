defmodule DealogBackofficeWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Generate the all errors list.

  This is used on top of the form to give a quick overview of what was erroneous.
  """
  def all_errors(errors, fields_with_labels) do
    Enum.map(errors, fn {field, errors} ->
      errors = Enum.map(errors, &translate_error({&1, []}))
      glue = Gettext.dgettext(DealogBackofficeWeb.Gettext, "errors", "and")
      "#{Keyword.get(fields_with_labels, field)} #{Enum.join(errors, " #{glue} ")}"
    end)
  end

  @doc """
  Check if the given changeset has errors.
  """
  def has_errors?(%Ecto.Changeset{} = changeset) do
    changeset.action && not changeset.valid?
  end

  @doc """
  Check if the given form field has errors.
  """
  def has_errors?(form, field) do
    # TODO Consolidate form error processing
    case Map.from_struct(form).errors do
      # The default Phoenix way
      errors when is_list(errors) -> Keyword.has_key?(errors, field)
      # The custom form implementation for DEalog
      errors when is_map(errors) -> Map.has_key?(errors, field)
    end
  end

  @doc """
  Generate the error message(s) for a specific field.
  """
  @deprecated "Please do not use this function anymore and switch to error_tag/3"
  def errors_for_field(form, field, opts \\ []) do
    if Map.has_key?(Map.from_struct(form).errors, field) do
      content_tag(:span, translate(Map.get(Map.from_struct(form).errors, field)),
        class: Keyword.get(opts, :class, ""),
        phx_feedback_for: input_id(form, field)
      )
    end
  end

  defp translate(errors) when is_list(errors) do
    errors = Enum.map(errors, &translate_error({&1, []}))
    glue = Gettext.dgettext(DealogBackofficeWeb.Gettext, "errors", "and")
    Enum.join(errors, " #{glue} ")
  end

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field, opts \\ []) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error), opts)
    end)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(DealogBackofficeWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(DealogBackofficeWeb.Gettext, "errors", msg, opts)
    end
  end
end
