class User < ApplicationRecord
    has_secure_password

    validates :email, presence: true, uniqueness: true, length: { maximum: 100 }
    validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end  