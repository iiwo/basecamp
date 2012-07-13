module Basecamp

  class Project < ActiveResource::Base
   class << self

     def list
       ActiveSupport::JSON.decode RestClient.get "#{Basecamp.site}/projects.json", :authorization => Basecamp.auth_header
     end

     # "name" => "name"
     def find(options)
       begin
         option = options.first
         @projects =  list
         @projects.each do |project|
           return OpenStruct.new(project) if project[option.first] == option.second
         end
         nil
       rescue
         nil
       end
     end

     # id or name
     def delete(options)
       begin
         option = options.first
         project = find(option.first => option.second)
         return true if project.nil?
         id = project.id
         RestClient.delete "#{Basecamp.site}/projects/#{id}.json", :authorization => Basecamp.auth_header
         true
       rescue
         false
       end
     end

     #name => "name", :description => "description"
     def create(data)
       begin
         json_data = data.to_json
         project = RestClient.post "#{Basecamp.site}/projects.json", json_data, :authorization => Basecamp.auth_header, :content_type => :json, :accept => :json
         OpenStruct.new( ActiveSupport::JSON.decode  project )
       rescue
         false
       end
     end

     def add_access(options, email)
       begin
         project = find(options)
         if project.nil?
           false
         else
           Basecamp::Access.add_email(project.id, email)
         end
       rescue
         false
       end
     end

     def access_list(options)
       begin
         project = find(options)
         Basecamp::Access.list(project.id)
       rescue
         false
      end
     end

     def delete_access(options, email)
       project = find(options)
       if project.nil?
         false
       else
         access = Basecamp::Access.find(project.id, email)
         if access
           Basecamp::Access.delete(access.id, project.id)
         end
         true
       end
     end

     def name_exist(name)
       begin
         return true unless find("name" => name).nil?
         false
       rescue
         false
       end
     end

   end

  end

end