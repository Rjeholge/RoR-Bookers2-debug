class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end
  end
end

#ここで定義している@usersって、どこのusersだ？
#１、下記コードにて検索フォームから情報を受け取っている
#検索モデル params[:range]
#検索方法 params[:search]
#検索ワード params[:word]
#２、if分を使って、検索モデルをUser or Bookで条件分岐
#３、looksメソッドを使い、検索内容を取得し、変数に代入
