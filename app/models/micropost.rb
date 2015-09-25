class Micropost < ActiveRecord::Base
    belongs_to :user
    validates :user_id, presence: true
    validates :content, presence: true, length: { maximum: 140 }
    
    has_many :favorites
    has_many :favorite_users, class_name: "User", foreign_key: "user_id", through: :favorites, source: :user, dependent: :destroy
end
