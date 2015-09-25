class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :favorite, index: true
      t.references :unfavorite, index: true
      
      t.timestamps null: false
      
      t.index [:favorite_id, :unfavorite_id], unique: true
    end
  end
end
