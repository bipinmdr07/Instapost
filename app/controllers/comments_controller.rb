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
        # format.html { redirect_to root_path}
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
  @comment = Post.find(params[:post_id]).comments.find(params[:id])
  if current_user != @comment.post.user.id
    if @comment.user != current_user
      redirect_to root_path
    end
  end
end
