require 'minitest/autorun'
require './lib/cell'

class CellTest < Minitest::Test
  def test_it_exists
    cell = Cell.new("B4")

    assert_instance_of Cell, cell
  end

  def test_it_has_coord
    cell = Cell.new("B4")

    assert_equal "B4", cell.coord
  end

  def test_it_starts_with_no_ship
    cell = Cell.new("B4")

    assert_nil cell.ship
  end

  def test_it_gets_a_ship_when_placed
    cell = Cell.new("B4")
    boat = Ship.new("Boot", 5)

    cell.place_ship(boat)

    assert_instance_of Ship, cell.ship
    assert_equal boat, cell.ship
    refute cell.empty?
  end

  def test_it_is_not_fired_upon_initially
    cell = Cell.new("B4")
    boat = Ship.new("Boot", 5)

    refute cell.fired_upon?
  end

  def test_a_hit
    cell = Cell.new("B4")
    boat = Ship.new("Boot", 5)

    cell.place_ship(boat)
    cell.fire_upon

    assert cell.fired_upon?
    assert_equal 4, cell.ship.health
  end

  def test_it_initially_renders_dot
    cell = Cell.new("B4")

    assert_equal ".", cell.render
  end

  def test_it_renders_m_after_miss
    cell = Cell.new("B4")

    cell.fire_upon

    assert_equal "M", cell.render
  end

  def test_it_renders_h_after_hit
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)

    cell.place_ship(cruiser)
    cell.fire_upon

    assert_equal "H", cell.render
  end

  def test_it_renders_x_after_sinking
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)

    cell.place_ship(cruiser)
    cell.fire_upon
    cell.fire_upon
    cell.fire_upon

    assert cell.ship.sunk?
    assert_equal "X", cell.render
  end

  def test_it_renders_dot_for_non_fired_cells_with_ship
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)

    cell.place_ship(cruiser)

    assert_instance_of Ship, cell.ship
    assert_equal ".", cell.render
  end

  def test_it_renders_s_for_non_fired_cells_with_ship_with_reveal
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)

    cell.place_ship(cruiser)

    assert_instance_of Ship, cell.ship
    assert_equal "S", cell.render(true)
  end
end
