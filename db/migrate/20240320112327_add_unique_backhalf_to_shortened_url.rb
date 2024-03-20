class AddUniqueBackhalfToShortenedUrl < ActiveRecord::Migration[6.0]
  def up
    remove_index :shortened_urls, column: [:original_url, :backhalf]
    remove_index :shortened_urls, :backhalf
    add_index :shortened_urls, :backhalf, unique: true 
  end
  
  def down
    add_index :shortened_urls, column: [:original_url, :backhalf]
    remove_index :shortened_urls, :backhalf, unique: true 
    add_index :shortened_urls, :backhalf
  end
end
