class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255}, 
                      format: {with: VALID_EMAIL_REGEX }, 
                      uniqueness: { case_sensitive: false }
    has_secure_password
    
    validates :description, presence: true, length: { maximum: 140 }, on: :update
    validates :area, presence: true, length: { maximum: 30 }, on: :update
    has_many :microposts
    
    has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :following_users, through: :following_relationships, source: :followed
    
    has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower
    
    has_many :favorites, dependent: :destroy
    has_many :favorite_microposts, class_name: "Micropost", foreign_key: "micropost_id", through: :favorites, source: :micropost
    
    # 他のユーザーをフォローする
    def follow(other_user)
        following_relationships.create(followed_id: other_user.id)
    end
    
    # フォローしているユーザーを解除する
    def unfollow(other_user)
        following_relationships.find_by(followed_id: other_user.id).destroy
    end
    
    #フォローしているかどうか
    def following?(other_user)
        following_users.include?(other_user)
    end
    
    # 他の投稿をお気に入りする
    def favorite(other_micropost)
        favorites.create(micropost_id: other_micropost.id)
    end
    
    # お気に入りしている投稿を削除する
    def unfavorite(other_micropost)
        favorites.find_by(micropost_id: other_micropost.id).destroy
    end
    
    # ある投稿をお気に入りしているかどうか？
    def favorite?(other_micropost)
        favorites.include?(other_micropost)
    end
    
    #ユーザーのつぶやきを取得する
    def feed_items
        Micropost.where(user_id: following_user_ids + [self.id])
    end
end
