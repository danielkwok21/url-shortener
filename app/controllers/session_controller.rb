class SessionController < ApplicationController 
    def index
        if session[:user_id] == nil 
            render :index
        else
            redirect_to root_path
        end
    end

    def create
        # attempt find user
        user = User.find_by(email: login_params[:email])

        # handle user not found
        if !user.presence
            flash[:alert] = "user not found"
            render :index
            return
        end

        # attempt login
        if user.authenticate(login_params[:password])
            session[:user_id] = user.id
            redirect_to root_path, notice: "Logged in as #{user.name}"
        else
            flash[:alert] = "invalid email or password"
            render :index
        end
    end

    def delete
        session[:user_id] = nil
        redirect_to root_path, notice: "Logged out"
    end

    @private
    def login_params
      params.permit(:email, :password)
    end
end