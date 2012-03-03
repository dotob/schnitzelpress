require "thor"

module Schnitzelpress
  class Cli < Thor
    include Thor::Actions

    source_root(File.expand_path('../../templates', __FILE__))

    desc "create NAME", "Creates a new Schnitzelpress blog."
    method_option :git, :aliases => "-g", :default => false,
      :desc => "Initialize a git repository in your blog's directory."
    method_option :bundle, :aliases => "-b", :default => false,
      :desc => "Run 'bundle install' after generating your new blog."

    def create(name)
      @name = name
      self.destination_root = name
      directory 'new_blog', '.'

      in_root do
        run "bundle"   if options[:bundle]
        run "git init" if options[:git]
      end
    end

    desc "console", "Run the Schnitzelpress console."
    def console
      require 'schnitzelpress'
      require 'pry'
      Schnitzelpress.init!
      ARGV.clear
      pry Schnitzelpress
    end
  end
end
