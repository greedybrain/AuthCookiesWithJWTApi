class ApplicationController < ActionController::Base
        skip_before_action :verify_authenticity_token
        helper_method :current_user

        def encode_token(payload)
                JWT.encode(payload, Rails.env(JWT_SECRET))
        end

        def auth_header 
                request.headers['Authorization']
        end

        def decoded_token 
                if auth_header
                        token = auth_header.split(' ')[1]
                        begin 
                                JWT.decode(token, Rails.env(JWT_SECRET), true, algorithm: Rails.env(JWT_ALGO))
                        rescue JWT::DecodeError
                                nil
                        end
                end
        end

        def current_user 
                if decoded_token
                        user_id = decoded_token[0]['user_id']
                        @current_user = User.find_by(session[:user_id])
                        render json: {
                                logged_in: true,
                                user: @current_user
                        }
                else
                        render json: {
                                logged_in: false
                        }
                end
        end

        def logged_in
                !!current_user
        end

        def authorized
                render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
        end

end
