class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # foreign_key（FK）には、@user.xxxとした際に「@user.idがfollower_idなのかfollowed_idなのか」を指定します。
    #has_many :xxx, class_name: "モデル名", foreign_key: "○○_id", dependent: :destroy
  # @user.booksのように、@user.yyyで、
  # そのユーザがフォローしている人orフォローされている人の一覧を出したい
    #has_many :yyy, through: :xxx, source: :zzz

  #１ followed = フォローされる人から見た、自分をフォローしてくれてる人たち(フォロワーさんたち)一覧
  #         ↓viewで呼び出す時に使用する
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
 #自分をフォローしてる人たちを、中間テーブル"reverse_of_relationships"を通じて確認します。情報元はRelationshipモデルで取ってきたfollowerという情報です。
 #中間テーブルを経由して「多対多」のテーブルへアソシエーションを組むには、これまで使用してきたhas_manyメソッドに、throughオプションを記述する必要がある。
 #親要素(この場合はfollowed_id側のuser)が孫要素(この場合はfollower_id側のuserたち)の情報にアクセスしたい場合、中間テーブルを介する必要がある。
 #中間テーブルにおいては、どのfollowed_userがどのfollower_userを持ってるか？という情報を持っている。

  #２ follower = フォローする人から見た、自分がフォローしてる人たち(フォローウィングしてる人たち)一覧
  #↓viewで呼び出す時に使用する
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
 #          ↑フォローしてる人たち、の意味で"followings"とした
 #自分がフォローしてる人たちを、中間テーブル"relationships"を通じて確認します。情報元はRelationshipモデルで取ってきたfollowedという情報です。

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  def self.search_for(word, search)
    if search == 'perfect'
      User.where(name: word)
    elsif search == 'forward'
      User.where('name LIKE ?', word+'%')
    elsif search == 'backward'
      User.where('name LIKE ?', '%'+word)
    else
      User.where('name LIKE ?', '%'+word+'%')
    end
  end
end
