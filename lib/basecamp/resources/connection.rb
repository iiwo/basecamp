module Basecamp

  class Connection < ActiveResource::Base

    class << self

      def test
        begin
          RestClient.get "#{Basecamp.site}/people.json", :authorization => Basecamp.auth_header
          true
        rescue
          false
        end
      end

    end

  end

end