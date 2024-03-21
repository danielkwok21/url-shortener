class AddForeignKeyToShortenedUrls < ActiveRecord::Migration[6.0]
  def up
    add_foreign_key :clicks, :shortened_urls
  end
  def up
    remove_foreign_key :clicks, :shortened_urls
  end
end
