class AddUserIdToShortenedUrl < ActiveRecord::Migration[6.0]
  def up
    add_reference :shortened_urls, :user, foreign_key: true
  end
  
  def down
    remove_reference :shortened_urls, :user, foreign_key: true
  end
end
