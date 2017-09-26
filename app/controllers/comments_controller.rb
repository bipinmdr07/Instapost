class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :is_owner?, only: :destroy

  def index
    @comment = Comments.where(post_id: params[:post_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params.merge(user_id: current_user.id))
    if @comment.valid?
      respond_to do |format|
        # debugger
        format.html { redirect_to root_path}
        format.js {}
      end
    else
      flash[:danger] = "Invalid attributes"
      redirect_to root_path
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.comments.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js {}
    end
  end
end

private

def comment_params
  params.require(:comment).permit(:text, :post_id)
end

def is_owner?
  if params[:post_id] == nil
  else
    @comment = Post.find(params[:post_id]).comments.find(params[:id])
    if current_user != @comment.post.user.id
      if @comment.user != current_user
        flash[:warning] = "You are not authorized to delete this comment"
        redirect_to root_path
      end
    end
  end
  # if (params[:post_id] == nil)
  #   if Post.find(params[:id]).user != current_user
  #     redirect_to root_path
  #     flash[:warning] = "You are not authorized to delete this post"
  #   end
  # # in case the user is trying to delete the comment
  # else
  #   redirect_to root_path if Post.find(params[:post_id]).user != current_user
  # end
end
