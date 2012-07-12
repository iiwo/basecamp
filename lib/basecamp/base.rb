module Basecamp
  class << self
    attr_reader :site, :auth_header, :bearer

    def establish_connection(site, bearer)
      @site     = site
      @bearer   = bearer
      @auth_header   = "Authorization: Bearer #{@bearer}"
    end

   end
end