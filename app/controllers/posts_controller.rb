class PostsController < ApplicationController
  before_action :check_logon, except: %w[show]
  before_action :set_forum, only: %w[create new]
  before_action :set_post, only: %w[show edit update destroy]
  before_action :check_access, only: %w[edit update delete] # access control!! a user can only

  def create
    @post = @forum.posts.new(post_params)  # we create a new post for the current forum
    @post.save
    redirect_to @post, notice: "Your post was created."
  end
  
  def new
    @post = @forum.posts.new  
  end
  
  def edit    # nothing to do here
  end
  
  def show    # nothing to do here
  end
  
  def update
    some_post = Post.new(post_params)
    @post.title = some_post.title
    @post.content = some_post.content
    @post.save
    redirect_to @post, notice: "Your post was updated."
  end
  
  def destroy
    @forum = @post.forum # we need to save this, so we can redirect to the forum after the destroy
    if @post.user == @current_user
      @post.destroy
      redirect_to @forum, notice: "Your post was deleted."
    else
      redirect_to @forum, notice: "You can't delete post by other author."
    end
  end

  private

  def check_logon 
    if !@current_user
      redirect_to forums_path, notice: "You can't add, modify, or delete posts before logon."
    end
  end

  def set_forum
    @forum = Forum.find(params[:forum_id])  # If you check the routes for posts, you see that this is the 
  end                                         # forum parameter

  def set_post
    @post = Post.find(params[:id])
  end

  def check_access
    if @post.user_id != session[:current_user]
      redirect_to forums_path, notice: "That's not your post, so you can't change it."
    end
  end

  def post_params   # security check, also known as "strong parameters"
    params[:post][:user_id] = session[:current_user] 
       # here we have to add a parameter so that the post is associated with the current user
    params.require(:post).permit(:title,:content,:user_id)
  end
end
