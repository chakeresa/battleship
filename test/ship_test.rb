require 'minitest/autorun'
require './lib/ship'

class ShipTest < Minitest::Test
  def test_it_exists
    cruiser = Ship.new("Cruiser", 3)

    assert_instance_of Ship, cruiser
  end

  def test_it_has_a_name
    cruiser = Ship.new("Cruiser", 3)

    assert_equal "Cruiser", cruiser.name
  end

  def test_it_has_a_length
    cruiser = Ship.new("Cruiser", 3)

    assert_equal 3, cruiser.length
  end

  def test_the_health
    cruiser = Ship.new("Cruiser", 3)

    assert_equal 3, cruiser.health
  end

  def test_sunk_starts_false
    cruiser = Ship.new("Cruiser", 3)

    refute cruiser.sunk?
  end

  def test_hits_decrease_health
    cruiser = Ship.new("Cruiser", 3)

    cruiser.hit

    assert_equal 2, cruiser.health
  end

  def test_hits_sink_ship
    cruiser = Ship.new("Cruiser", 3)

    cruiser.hit
    cruiser.hit
    cruiser.hit

    assert cruiser.sunk?
  end
end
