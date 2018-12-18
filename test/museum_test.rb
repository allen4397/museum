require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'
require './lib/museum'

class MuseumTest < Minitest::Test
  def test_it_exists
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_instance_of Museum, dmns
  end

  def test_it_has_a_name
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal "Denver Museum of Nature and Science", dmns.name
  end

  def test_it_starts_with_no_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.exhibits
  end

  def test_it_can_add_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [gems_and_minerals, dead_sea_scrolls, imax], dmns.exhibits
  end

  def test_it_can_recommend_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")

    assert_equal [dead_sea_scrolls, gems_and_minerals], dmns.recommend_exhibits(bob)
    assert_equal [imax], dmns.recommend_exhibits(sally)
  end

  def test_it_starts_with_no_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.patrons
  end

  def test_it_can_admit_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")
    bob = Patron.new("Bob", 20)
    sally = Patron.new("Sally", 20)

    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal [bob, sally], dmns.patrons
  end

  def test_it_tracks_patrons_by_exhibit_interest
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal ({
                    gems_and_minerals => [bob],
                    dead_sea_scrolls => [bob, sally],
                    imax => []
      }), dmns.patrons_by_exhibit_interest
  end

  def test_patrons_do_not_attend_exhibits_they_do_not_have_money_for
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")

    dmns.admit(tj)

    assert_equal 7, tj.spending_money
  end

  def test_patrons_attend_exhibits_they_are_into_if_they_have_enough_money
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")

    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal 0, bob.spending_money
    assert_equal 5, sally.spending_money
  end
end
