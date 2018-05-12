require 'url_checker'

class UrlPair < ApplicationRecord
    validates :original, presence: true
    validates :shortened, presence: true, uniqueness: true
    validate :check_valid_url
    
    before_create :set_user_token
    
    default_scope { order(created_at: :desc) }
    
    def self.generate_random_shortened_path
        return loop do
          random_path = SecureRandom.urlsafe_base64(nil, false)[0...10]
          break random_path unless self.exists?(shortened: random_path)
        end
    end
    
    def self.generate_user_token
        return loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless self.exists?(user_token: random_token)
        end
    end
    
    private
        
        def check_valid_url
            unless UrlChecker.is_valid_url?(self.original)
                errors.add(:original, "Wrong URL")
            end
        end
        
        def set_user_token
            self.user_token = UrlPair.generate_user_token if self.user_token.blank?
        end
        
end
