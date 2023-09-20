class AddColumnToBookmarks < ActiveRecord::Migration[7.0]
  def change
    add_column :bookmarks, :movie_title, :string
  end
end
