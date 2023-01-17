defmodule Gettext.Plural.Expo do
  @behaviour Gettext.Plural

  alias Expo.PluralForms

  @impl Gettext.Plural
  def init(context)

  def init(%{plural_forms_header: plural_forms_header}),
    do: PluralForms.parse!(plural_forms_header)

  def init(%{locale: locale}) do
    {:ok, plural_form} = PluralForms.plural_form(locale)
    plural_form
  end

  @impl Gettext.Plural
  def nplurals(%PluralForms{nplurals: nplurals}), do: nplurals

  @impl Gettext.Plural
  def plural(%PluralForms{} = plural_form, count),
    do: PluralForms.index(plural_form, count)

  @impl Gettext.Plural
  def plural_forms_header(locale) do
    case PluralForms.plural_form(locale) do
      :error -> nil
      {:ok, plural_forms} -> PluralForms.to_string(plural_forms)
    end
  end
end
