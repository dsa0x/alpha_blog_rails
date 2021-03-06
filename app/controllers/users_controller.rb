class UsersController < ApplicationController
    before_action :set_user, only: [:edit,:update,:show]
    before_action :validate_user, only: [:edit,:update,:destroy]
    before_action :require_admin, only: [:destroy]
    def index
        @users = User.paginate(page: params[:page], per_page: 2)
    end
    
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:success] = "Welcome to the alpha blog #{@user.username}"
            redirect_to user_path(@user)
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        if @user.update(user_params)
            flash[:success] = "Your account was updated successfully"
            redirect_to articles_path
        else
            flash[:notice] = @user.errors.full_messages
            render 'edit'
        end
    end

    def show
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        flash[:danger] = "User and all articles created by user have been deleted"
        redirect_to users_path
    end

    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
        flash[:warning] = "User not found"
        redirect_to root_path
    end
    
    
    private
    def user_params
        params.require(:user).permit(:username,:email,:password)
    end

    def validate_user
        if @user != current_user && !current_user.admin?
            flash[:danger] = "You can only edit own profile"
            redirect_to root_path
        end
    end

    def require_admin
        if logged_in? && !current_user.admin?
            flash["Only admin users can perform that action"]
            redirect_to root_path
        end
    end

    
end