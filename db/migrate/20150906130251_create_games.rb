class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :score
      t.boolean :continue_game
      t.boolean :continue_round
      t.integer :player_one
      t.integer :player_two

      t.timestamps null: false
    end
  end
end
