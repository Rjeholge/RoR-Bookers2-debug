class Relationship < ApplicationRecord
  #１　followed = フォローされる人のID
  belongs_to :followed, class_name: "User"

  #２　follower = フォローする人のID
  belongs_to :follower, class_name: "User"
end
