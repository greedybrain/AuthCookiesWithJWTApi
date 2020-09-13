class SessionsController < ApplicationController

        def login 
                user = User.find_by(email: params[:email])
                
                if user&.authenticate(params[:password])
                session[:user_id] = user.id 
                render json: {
                        status: :created,
                        logged_in: true,
                        user: UserSerializer.new(user)
                }
                else
                render json: {
                        status: 401
                }
                end
        end

end
