class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

#下記に記述を変更
  #def favorited_by?(user)
    #favorites.exists?(user_id: user.id)
  #end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
