class MainController < ApplicationController
    before_action :set_user_token, only: [:create]
    before_action :get_url_pair, only: [:show]
    
    def index
        @url_pair = UrlPair.new
        @user_url_pairs = UrlPair.where(:user_token => cookies.signed[:user_token]) if cookies.signed[:user_token]
    end
    
    def show
        @url_pair.update_attribute(:visits_count, @url_pair.visits_count + 1)
        redirect_to @url_pair.original
    end
    
    def create
        @url_pair = UrlPair.new(url_pair_params)
        @url_pair.user_token = cookies.signed.permanent[:user_token]
        unless @url_pair.save
            render 'new'
        end
        
    end
    
    private
        
        def url_pair_params
            params.require(:url_pair).permit(:original, :shortened)
        end
        
        def set_user_token
            cookies.signed.permanent[:user_token] = UrlPair.generate_user_token unless cookies.signed[:user_token]
        end
        
        def get_url_pair
            @url_pair = UrlPair.find_by(shortened: params[:id].to_s)
            unless @url_pair
                redirect_to root_url and return
            end
        end
    
end
