# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
project_type = :rails
project_path = Compass::AppIntegration::Rails.root
# Set this to the root of your project when deployed:
http_path = '/'
sass_dir  = 'app/stylesheets'
css_dir   = 'public/stylesheets'
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

if Rails.env.production?
  output_style = :compressed
  css_dir = "tmp/stylesheets"
end
environment = Compass::AppIntegration::Rails.env
