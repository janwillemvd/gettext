defmodule Gettext.Plural.ExpoTest.Backend do
  use Gettext,
    otp_app: :gettext,
    plural_forms: Gettext.Plural.Expo,
    priv: "test/fixtures/expo_plural"
end

defmodule Gettext.Plural.ExpoTest do
  use ExUnit.Case

  alias Expo.Messages

  import Gettext.Plural.ExpoTest.Backend

  test "uses the correct translation" do
    # Has Plural Forms header with override
    Gettext.put_locale("zh_p")

    assert ngettext("test", "tests", 1) == "0"
    assert ngettext("test", "tests", 2) == "1"

    # Does not have a header, falling back to default
    Gettext.put_locale("de")

    assert ngettext("test", "tests", 1) == "0"
    assert ngettext("test", "tests", 2) == "1"
  end

  test "creates correct plural forms header for new file" do
    Application.put_env(:gettext, :plural_forms, Gettext.Plural.Expo)

    on_exit(fn ->
      Application.put_env(:gettext, :plural_forms, Gettext.Plural)
    end)

    assert {messages, _stats} =
             Gettext.Merger.new_po_file(
               "test/fixtures/expo_plural/fr/LC_MESSAGES/default.po",
               "test/fixtures/expo_plural/default.pot",
               "fr",
               []
             )

    assert Messages.get_header(messages, "Plural-Forms") == ["nplurals=2; plural=(n>1);"]
  end
end
