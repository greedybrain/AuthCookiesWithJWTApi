class Api::V1::SessionsController < ApplicationController
        def login 
                user = User.find_by(email: params[:email].capitalize) || User.find_by(email: params[:email])
                if user&.authenticate(params[:password])
                        session[:user_id] = user.id 
                        created_jwt = encode_token(session[:user_id])
                        cookies.signed[:jwt] = { value: created_jwt, httponly: true, expires: 1.hour.from_now }
                        # UserMailer.welcome_email(user).deliver_now
                        render json: {
                                status: :created,
                                logged_in: true,
                                user: UserSerializer.new(user)
                        }
                else
                        render json: {
                                status: 500,
                                error: "Incorrect username and/or password"
                        }
                end
        end

        def logged_in 
                if current_user
                        render json: {
                                user: UserSerializer.new(current_user),
                                logged_in: true
                        }
                else
                        render json: {
                                logged_in: false
                        }
                end
        end

        def logout
                session.clear
                render json: {
                     status: 200,
                     logged_in: false
                }
           end

end
