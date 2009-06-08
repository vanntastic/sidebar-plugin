module Innerfusion
  module Sidebar
    
    # generate your sidebars directory with the following task:
    # rake sidebar:install
    # == display_sidebar
    # displays a sidebar, it will search for sidebar partial files in the following areas:
    # 1. views/sidebars/[:controller]/[:action] # => action specific sidebar
    # 2. views/sidebars/[:controller]/global # => controller specific sidebar
    # 3. views/sidebars/global # => app wide specific sidebar
    # to generate a sidebar skeleton dir, use the following rake task
    # rake sidebar:generate FOR='controller/action'
    # you can set the message to display by passing it in the block
    # display_sidebar { "Nothing to see" } # => will display "Nothing to see" if sidebar isn't 
    #                                           found
    # you can specify a wrapping element by using the following syntax
    # display_sidebar :inside => '<div id="sidebars">yield</div>'
    #         - yield will be substituted with the sidebar
    # 
    def display_sidebar(options={}, &block)
      options[:inside] ||= ""
      sidebar_partial = "sidebars/#{params[:controller]}/#{params[:action]}"
      sidebar_file = File.join(RAILS_ROOT, "app/views/sidebars", params[:controller], 
                              "_#{params[:action]}.html.erb")
      old_sidebar_file = File.join(RAILS_ROOT, "app/views/sidebars", params[:controller],
                              "_#{params[:action]}.rhtml")                        

      controller_sidebar_partial = "sidebars/#{params[:controller]}/global"                        
      controller_sidebar_file = File.join(RAILS_ROOT, 
                                "app/views/sidebars/#{params[:controller]}/_global.html.erb")
      old_controller_sidebar_file = File.join(RAILS_ROOT, 
                                "app/views/sidebars/#{params[:controller]}/_global.rhtml")

      global_sidebar_file = "#{RAILS_ROOT}/app/views/sidebars/_global.html.erb"
      old_global_sidebar_file = "#{RAILS_ROOT}/app/views/sidebars/_global.rhtml"
      global_sidebar_partial = "sidebars/global"
      
      
      if File.exists?(sidebar_file) || File.exists?(old_sidebar_file)
        side_bar = render(:partial => sidebar_partial)
        options[:inside].blank? ? side_bar : options[:inside].gsub("yield",side_bar)
      elsif File.exists?(controller_sidebar_file) || File.exists?(old_controller_sidebar_file)
        side_bar = render :partial => controller_sidebar_partial
        options[:inside].blank? ? side_bar : options[:inside].gsub("yield",side_bar)
      else
        content = "" || yield
        if File.exists?(global_sidebar_file) || File.exists?(old_global_sidebar_file)
          global_sidebar = render(:partial => global_sidebar_partial)
          options[:inside].blank? ? global_sidebar : options[:inside].gsub("yield", global_sidebar) 
        else
          content
        end
      end
    end
    
    # if you need to quickly copy a sidebar from another within the same
    # controller, here's the easy way :
    # copy_from :name_of_sidebar
    #   # => render :partial => 'sidebars/#{params[:controller]}/#{sidebar}'
    # you can also copy a sidebar from another controller by passing the controller hash
    # copy_from :index, :controller => "home"
    #   # => render :partial => 'sidebars/home/index'
    # you can also use a string if you want to as well...
    # copy_from "home/index"
    #   # => render :partial => "sidebars/home/index"
    def copy_from(sidebar, options={})
      options[:controller] ||= params[:controller] 
      partial = "sidebars/#{options[:controller]}/#{sidebar.to_s}" if sidebar.is_a?(Symbol)
      partial = File.join "sidebars", sidebar if sidebar.is_a?(String)
      render :partial => partial
    end
    
  end
end