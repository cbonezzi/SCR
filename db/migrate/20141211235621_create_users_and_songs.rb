class CreateUsersAndSongs < ActiveRecord::Migration
  def change
    create_table :users_songs, id: false do |t|
      t.belongs_to :users
      t.belongs_to :songs
    end
  end
end
