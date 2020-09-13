class SessionsController < ApplicationController
        def login 
                user = User.find_by(email: params[:email].capitalize) || User.find_by(email: params[:email])
                if user&.authenticate(params[:password])
                        session[:user_id] = user.id 
                        render json: {
                                status: :created,
                                logged_in: true,
                                user: UserSerializer.new(user)
                        }
                elsif user 
                        render json: {
                                status: 500,
                                password_error: ["*Wrong Password!"],
                        }
                else
                        render json: {
                                status: 500,
                                email_error: ["*Email Not Found!"]
                        }
                end
        end

        def logged_in 
                
        end

        def logout
                session.clear
                render json: {
                     status: 200,
                     logged_out: true
                }
           end

end
