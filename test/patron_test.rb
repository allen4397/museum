require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'

class PatronTest < Minitest::Test
  def test_it_exists
    bob = Patron.new("Bob", 20)

    assert_instance_of Patron, bob
  end
end
