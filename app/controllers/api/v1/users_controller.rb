class Api::V1::UsersController < ApplicationController

        def index 
                users = User.order('created_at DESC')
                render json: {
                        users: UserSerializer.new(users)
                }
        end

end
