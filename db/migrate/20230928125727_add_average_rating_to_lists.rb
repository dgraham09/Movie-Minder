class AddAverageRatingToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :average_rating, :integer
  end
end
