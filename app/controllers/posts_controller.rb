class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
    def index
      @posts= Post.all
      @tags = Tag.all
      post_ids = []

      if params[:tag_ids]
        params[:tag_ids].each do |key, value| 
          Tag.find_by(name: key).posts.each { |p| post_ids << p.id } if value == "1"
        end
        post_ids.uniq!
        @posts.where!(id: post_ids) if post_ids.present?
      end
      @posts.where!("age LIKE ? ",'%' + params[:search] + '%') if params[:search]
    end
    def new
        @post = Post.new
      end
    
      def create
        post = Post.new(post_params)
        post.user_id = current_user.id
        if post.save!
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
      end
      def show
        @post = Post.find(params[:id])
        @comments = @post.comments
        @comment = Comment.new
      end
      def edit
        @post = Post.find(params[:id])
      end
      def update
        post = Post.find(params[:id])
        if post.update(post_params)
          redirect_to :action => "show", :id => post.id
        else
          redirect_to :action => "new"
        end
      end
      def destroy
        post = Post.find(params[:id])
        post.destroy
        redirect_to action: :index
      end
      private
      def post_params
        params.require(:post).permit(:name, :age, :about, :image,:lat,:lng, tag_ids: [])
      end
end
