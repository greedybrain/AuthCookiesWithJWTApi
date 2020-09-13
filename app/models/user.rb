class User < ApplicationRecord
        has_secure_password

        validates :email, uniqueness: true,  with: URI::MailTo::EMAIL_REGEXP
end