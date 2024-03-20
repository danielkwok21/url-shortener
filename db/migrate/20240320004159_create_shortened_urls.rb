class CreateShortenedUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :shortened_urls do |t|
      t.string :original_url, null: false
      t.string :backhalf, limit: 15, null: false
      t.string :title, limit: 300

      t.timestamps
    end

    add_index :shortened_urls, [:original_url, :backhalf], unique: true, name: 'uk_original_url_backhalf'
    add_index :shortened_urls, :backhalf
  end

  def down
    remove_index :shortened_urls, name: 'uk_original_url_backhalf'
    remove_index :shortened_urls, :backhalf
    drop_table :shortened_urls
  end
end
