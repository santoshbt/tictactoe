require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "Save player with name" do
    player = Player.new(:name => "Jon", :marker => "X")
    player.save 
    assert_not player.save, "Player saved successfully."
  end
end
