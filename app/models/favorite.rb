class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book

#追加　一意(=ユニーク)であることのバリデーション
  validates_uniqueness_of :book_id, scope: :user_id
end
