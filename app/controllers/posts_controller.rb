class PostsController < ApplicationController
  # FOR COMMENTS
  before_action :set_park, only: [:index]
  before_action :authenticate, only: [:create, :update, :destroy]
  # before_action :set_comment, only: [:index]

  # THIS SHOWS ALL COMMENTS FOR EVERY PARK. WE DON'T WANT THIS
  # Ideally, we need this to render comments that are associated with that id
  def index
    posts = Post.all.includes(:park, :user)
    if posts.id == @park
      render json: posts, include: { park: { only: :name }, user: { only: :username } }, status: 200
      puts "This comment exists"
    end
  end

  def create
    post = current_user.posts.create(post_params)
    unless post.errors.any?
      render json: post, include: { park: { only: :name }, user: { only: :username } }, status: 201
    else
      render json: { errors: post.errors.full_messages }, status: 422
    end
  end

  # PSEUDO CODE
  # Rendering comments that are ONLY for that particular park
  # def show
  #   if Park.id == post.park_id
  #     render json: @park, include: { category: { only: :name }, feature: { only: :name } }, status: 200
  #   end
  # end

  private

  def set_park
    begin
      @post = Post.find(params[:park_id])
      @park = Park.find(params[:id])
    rescue
      # Will run if exception is raised
      render json: { error: "Could not find this park" }, status: 404
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :park_id, :comment, :rating)
  end

  # def set_comment
  #   begin
  #     @post = Post.find(params[:park_id])
  #   rescue
  #     # Will run if exception is raised
  #     render json: { error: "Could not find this comment" }, status: 404
  #   end
  # end
end
