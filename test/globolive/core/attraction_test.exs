defmodule Globolive.Core.AttractionTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.Attraction

  describe "new/1" do
    test "creates a new attraction" do
      attributes = attraction_fields()
      assert %Attraction{} = Attraction.new(attributes)
    end
  end
end
