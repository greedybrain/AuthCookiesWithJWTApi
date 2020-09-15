class ApplicationController < ActionController::Base
        skip_before_action :verify_authenticity_token
        include ::ActionController::Cookies
        helper_method :current_user, :check_if_logged_in, :encode_token, :decoded_token

        def encode_token(payload)
                JWT.encode(payload, ENV['JWT_SECRET'])
        end

        def auth_header 
                request.headers['Authorization']
        end

        def decoded_token 
                if auth_header
                        token = auth_header.split(' ')[1]
                        begin 
                                JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: ENV['JWT_ALGO'])
                        rescue JWT::DecodeError
                                nil
                        end
                end
        end

        def current_user 
                @current_user ||= User.find(session[:user_id]) if session[:user_id]
                # if decoded_token
                #         user_id = decoded_token[0]['user_id']
                        
                #         render json: {
                #                 logged_in: true,
                #                 user: @current_user
                #         }
                # else
                #         render json: {
                #                 logged_in: false
                #         }
                # end
        end

        def check_if_logged_in
                !!current_user
        end

        def authorized
                render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
        end

end
