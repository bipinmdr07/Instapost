class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :is_owner?, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.valid?
      redirect_to root_path
      flash[:success] = "Congratulation!!! You have successfully created new post."
    elsif
      render :new, status: :unprocessable_entity
      flash[:danger] = "oops!!! something went wrong, Please try again."
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to root_path
    flash[:success] = "Your post has been deleted successfully!!!"
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    if @post.valid?
      redirect_to root_path
      flash[:success] = "Your post has been successfully updated!!!"
    else
      render :edit, status: :unprocessable_entity
      flash[:danger] = "Ooops!!! something went wrong, please try again."
    end
  end

  def show
    @post = Post.find(params[:id])
  end
end

private

def post_params
  params.require(:post).permit(:user_id, :photo, :description)
end

def is_owner?
  # in case the user is directly trying to delete the post itself
  if (params[:post_id] == nil)
    if Post.find(params[:id]).user != current_user
      redirect_to root_path
      flash[:warning] = "You are not authorized to delete this post"
    end
  # in case the user is trying to delete the comment
  else
    redirect_to root_path if Post.find(params[:post_id]).user != current_user
  end
end
