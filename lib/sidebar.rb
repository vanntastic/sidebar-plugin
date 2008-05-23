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
    
    def display_sidebar(&block)
      sidebar_partial = "sidebars/#{params[:controller]}/#{params[:action]}"
      sidebar_file = File.join(RAILS_ROOT, "app/views/sidebars", params[:controller], 
                              "_#{params[:action]}.rhtml")

      controller_sidebar_partial = "sidebars/#{params[:controller]}/global"                        
      controller_sidebar_file = File.join(RAILS_ROOT, "app/views/sidebars/#{params[:controller]}/_global.rhtml")

      global_sidebar_file = "#{RAILS_ROOT}/app/views/sidebars/_global.rhtml"
      global_sidebar_partial = "sidebars/global"

      if File.exists?(sidebar_file)
        render :partial => sidebar_partial
      elsif File.exists?(controller_sidebar_file)
        render :partial => controller_sidebar_partial
      else
        content = "" || yield
        File.exists?(global_sidebar_file) ? render(:partial => global_sidebar_partial) : content
      end
    end
    
    # if you need to quickly copy a sidebar from another within the same
    # controller, here's the easy way :
    # copy_from :name_of_sidebar
    #   # => render :partial => 'sidebars/#{params[:controller]}/#{sidebar}'
    def copy_from(sidebar)
      render :partial => "sidebars/#{params[:controller]}/#{sidebar.to_s}" 
    end
    
  end
end