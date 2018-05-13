class ApiController < ApplicationController
    before_action :set_user_token, only: [:truncate]
    before_action :validate_user_token, only: [:get_data]
    
    def truncate
        params[:shortened] = UrlPair.generate_random_shortened_path if params[:shortened].blank?
        @url_pair = UrlPair.new(original: params[:original], shortened: params[:shortened], user_token: params[:user_token])
        if @url_pair.save
            render json: {'status': 'ok', "data": @url_pair.attributes.slice('original', 'shortened', 'user_token') }
        else
            render json: {'status': 'fail', "data": @url_pair.errors.full_messages }
        end
    end
    
    def get_data
        if params[:original]
            @url_pairs = UrlPair.where(:user_token => params[:user_token], original: params[:original]).pluck(:original, :shortened, :visits_count, :created_at)
        else
            @url_pairs = UrlPair.where(:user_token => params[:user_token]).pluck(:original, :shortened, :visits_count, :created_at)
        end
        render json: {'status': 'ok', data: map_url_pairs }
    end
    
    private
    
        def set_user_token
            params[:user_token] = UrlPair.generate_user_token unless params[:user_token]
        end
        
        def validate_user_token
            if params[:user_token].blank?
                render json: {'status': 'fail', "data": "User token not provided" } and return
            end
        end
        
        def map_url_pairs
            @url_pairs.map do |item|
                {
                    'original': item[0],
                    'shortened': item[1],
                    'visits_count': item[2],
                    'expiring_at': (item[3] - 14.days).beginning_of_day.to_i
                }
            end
        end
end
