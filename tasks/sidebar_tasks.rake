require 'fileutils'

namespace :sidebar do
  desc 'Install the default skeleton sidebar dir structure'
  task :install do
    sidebar_path = File.join(RAILS_ROOT,"app/views/sidebars")
    global_sidebar = File.join sidebar_path, "_global.rhtml"
    FileUtils.mkdir_p sidebar_path
    File.open(global_sidebar, "w+") do |file|
      file << "<!-- This is the best sidebar ever! -->"
    end
    puts "The Sidebars Directory has been generated..."
  end
  
  desc 'Generate a sidebar skeleton with all the needed files under app/views/sidebar'
  task :generate do
    if ENV['FOR'].nil?
      puts "USAGE: rake sidebar:generate FOR='controller/action'"
      exit
    else
      controller, action = ENV['FOR'].split("/")[0], ENV['FOR'].split("/")[1]
      if action.nil?
        puts "You didn't pass in an action, pass it in like 'controller/action'"
        exit
      end
      sidebar_dir_path = "#{RAILS_ROOT}/app/views/sidebars/#{controller}/"
      FileUtils.mkdir_p sidebar_dir_path
      sidebar_partial_file = "#{sidebar_dir_path}/_#{action}.html.erb"
      File.open(sidebar_partial_file,"w+") do |file|
        file << "<!-- Add in content for your sidebar below -->"
      end
      puts "Sidebar template has been generated at : '#{sidebar_dir_path}'"
      # will open the sidebar in textmate
      system("mate #{sidebar_partial_file}") if system("mate")
    end  
  end
  
end
