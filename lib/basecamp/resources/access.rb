module Basecamp
  class Access < ActiveResource::Base

    class << self

      def list(project_id)
        begin
          ActiveSupport::JSON.decode RestClient.get "#{Basecamp.site}/projects/#{project_id}/accesses.json", :authorization => Basecamp.auth_header
        rescue
          false
        end
      end

      def add_email(project_id, email)
        begin
          ea = {"email_addresses" => [email]}
          RestClient.post "#{Basecamp.site}/projects/#{project_id}/accesses.json", ea.to_json, :authorization => Basecamp.auth_header,
                       :content_type => :json, :accept => :json
          true
        rescue
          false
        end
      end

      def find(project_id, email)
        accesses = list(project_id)
        accesses.each do |access|
          return access if(access["email_address"] == email)
        end
        false
      end

      def delete(id, project_id)
        begin
          RestClient.delete "#{Basecamp.site}/projects/#{project_id}/accesses/#{id}.json", :authorization => Basecamp.auth_header
          true
        rescue
          false
        end
      end


    end

  end
end