class UsersController < ApplicationController

    def index 
        users = User.all 
        render json: users, include: [:character, :teacher], except: [:password_digest]
    end

    def show
        user = User.find_by(id: params[:id])
        render json: user, include: [:character, :teacher],except: [:password_digest]
    end

    def update
        user = User.find_by(id: params[:id])
        user.update(user_params)
        render json: user
    end

    def teachers
        teachers = User.all.select do |user| 
            user.is_student == false
        end 
        render json: teachers
    end

    def create
        user = User.new(signup_params)

        if user.valid?
            user.save
            render json: {user: user}, status: :created 
        else   
            render json: {error: "Failed to create user"}, status: :not_acceptable 
        end
    end



    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :username, :password, :house, :alter_ego, :is_student, :teacher_id, :character_id, :character)
    end

    def signup_params
        params.permit(:username, :password, :first_name, :last_name)
    end
end
