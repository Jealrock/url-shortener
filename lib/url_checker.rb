class UrlChecker
    
    def self.is_valid_url?(url_string)
        begin
            RestClient::Request.execute(method: :get, url: url_string) do |response, request, result, &block|
                    return true if response.code == 200 
                    return false
            end
        rescue Errno::EINVAL, RestClient::Exception => e
            # In production printed to log/production.log
             puts "[#{Time.zone.now.to_formatted_s(:short)}] ERROR request: #{url_string} error: #{e.backtrace[0...3]}: #{e.message} (#{e.class})"
             return false
        end
    end
    
end