class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |table|
      table.integer :follower_id
      table.integer :followed_id

      table.timestamps
    end
  end
    add_indexes
  private

  def add_indexes
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
