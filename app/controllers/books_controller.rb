class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    @books = Book.all
    @book_comment = BookComment.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @new_book = Book.new
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end


  # Hataribar確認画面記述

  # def confirm
  #   @post = Post.new(@temporarily)
  #   if @post.invalid?
  #     render :new
  #   end
  # end

  # def back
  #   @post = Post.new(@temporarily)
  #   render :new
  # end

  # def complete
  #   Post.create!(@temporarily)
  # end

  #def create
    #post = Post.new(post_params)
    #post.save
    #redirect_to post_path(post.id)
  #end

    #def post_params
      #params.require(:post).permit(:user_id, :industry_id, :answer_what, :answer_employment_type,
      #:answer_working_style, :answer_income, :answer_how, :answer_skill, :answer_why,
      #:answer_aptitude, :answer_future, :answer_advantage, :answer_free)
    #end

      # @temporarily = params.require('post').permit(:id, :user_id, :industry_id, :answer_what, :answer_employment_status,
      # :answer_working_style, :answer_income, :answer_how, :answer_skill, :answer_why,
      # :answer_aptitude, :answer_future, :answer_advantage, :answer_free)

    # def move_to_signed_in
    #   unless user_signed_in?
    #     redirect_to new_user_session_path
    #   end
    # end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
