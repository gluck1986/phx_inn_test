defmodule Phx.InnCheckTest do
  use ExUnit.Case

  test "test 10th inn is valid" do
    assert Phx.Services.Inn.valid?("6449013711") === true
    assert Phx.Services.Inn.valid?("6349323710") === true
  end

  test "test 10th inn is invalid" do
    assert Phx.Services.Inn.valid?("6349023711") === false
    assert Phx.Services.Inn.valid?("6449013712") === false
  end

  test "test 12th inn is valid" do
    assert Phx.Services.Inn.valid?("500100732259") === true
    assert Phx.Services.Inn.valid?("644909589022") === true
  end

  test "test 12th inn is invalid" do
    assert Phx.Services.Inn.valid?("500100732258") === false
    assert Phx.Services.Inn.valid?("644909589021") === false
  end
end
