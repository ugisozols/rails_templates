def clean_gemfile
  run "rm Gemfile"
  run "touch Gemfile"
  add_source "https://rubygems.org"
end

def add_gems
  gem "rails", "~> 3.2.8"

  gem_group :development do
    gem "guard-rspec", "~> 1.2.1"
    gem "guard-livereload"
    gem "quiet_assets"
    gem "thin"
  end

  gem_group :development, :test do
    gem "rspec-rails", "~> 2.11"
  end

  gem_group :test do
    gem "factory_girl_rails", "~> 4.0.0"
    gem "ruby_gntp"
  end

  gem_group :assets do
    gem "sass-rails",   "~> 3.2.3"
    gem "coffee-rails", "~> 3.2.1"
    gem "uglifier", ">= 1.0.3"
    gem "bootstrap-sass", "~> 2.0.4"
  end
  gem "jquery-rails"
end

def remove_uneccessary_files_and_folders
  run "rm public/index"
  run "rm public/favicon.ico"
  run "rm app/assets/images/rails.png"
  run "rm -r doc/"
end

def configure_rspec
  generate "rspec:install"

  inject_into_file "config/application.rb", :after => "config.assets.version = '1.0'\n" do
<<-RUBY

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.view_specs false
    end
RUBY
  end

  inject_into_file "spec/spec_helper.rb", :after => "config.order = \"random\"\n" do
<<-RUBY

  config.include FactoryGirl::Syntax::Methods
RUBY
  end
end

def clean_application_css_and_add_bootstrap
  run "rm app/assets/stylesheets/application.css"
  run "touch app/assets/stylesheets/application.css.scss"
  append_file "app/assets/stylesheets/application.css.scss", '@import "bootstrap";'
end

clean_gemfile
add_gems
remove_uneccessary_files_and_folders
configure_rspec
clean_application_css_and_add_bootstrap
