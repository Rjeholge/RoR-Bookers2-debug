class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @search = params[:search]

    if @range == "user"
      @records = User.search_for(@word, @search)
    else
      @records = Book.search_for(@word, @search)
    end
  end
end

#１、下記コードにて検索フォームから情報を受け取っている
#検索モデル params[:range]
#検索方法 params[:search]
#検索ワード params[:word]
#２、if文を使って、検索モデルをUser or Bookで条件分岐
#３、search_forメソッドを使い、検索内容を取得し、変数@recordsに代入
