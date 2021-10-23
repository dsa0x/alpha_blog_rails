class UsersController < ApplicationController
    before_action :set_user, only: [:edit,:update,:show]
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Welcome to the alpha blog #{@user.username}"
            redirect_to articles_path
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

    def set_user
        @user = User.find(params[:id])
    end
    
    
    private
    def user_params
        params.require(:user).permit(:username,:email,:password)
    end

    
end