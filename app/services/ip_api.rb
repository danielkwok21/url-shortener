require 'net/http'
require 'json'

class IpApi
    BASE_URL = URI('http://ip-api.com/json')

    def get_details_by_ip(ip)
        response = Net::HTTP.get_response(BASE_URL)
        if response.is_a?(Net::HTTPSuccess)
            return response.body
        else
            return response.code
        end
    end
end