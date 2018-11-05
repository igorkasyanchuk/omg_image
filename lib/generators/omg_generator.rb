class OmgGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  
  def create_omg_file
    directory "app/omg"
  end
end