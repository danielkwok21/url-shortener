class ShortenedUrl < ApplicationRecord
    validates :original_url, presence: true
    validates :backhalf, presence: true
end
