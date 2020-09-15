class Api::V1::SessionsController < ApplicationController
        def login 
                user = User.find_by(email: params[:email].capitalize) || User.find_by(email: params[:email])
                if user&.authenticate(params[:password])
                        session[:user_id] = user.id 
                        created_jwt = encode_token(session[:user_id])
                        cookies.signed[:jwt] = { value: created_jwt, httponly: true, expires: 1.hour.from_now }
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
                     logged_out: true
                }
           end

end
