# DO NOT MODIFY THIS FILE
# Generated by Bundler 0.9.25

require 'digest/sha1'
require 'yaml'
require 'pathname'
require 'rubygems'
Gem.source_index # ensure Rubygems is fully loaded in Ruby 1.9

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  class Specification < Gem::Specification
    attr_accessor :relative_loaded_from

    def self.from_gemspec(gemspec)
      spec = allocate
      gemspec.instance_variables.each do |ivar|
        spec.instance_variable_set(ivar, gemspec.instance_variable_get(ivar))
      end
      spec
    end

    def loaded_from
      return super unless relative_loaded_from
      source.path.join(relative_loaded_from).to_s
    end

    def full_gem_path
      Pathname.new(loaded_from).dirname.expand_path.to_s
    end
  end

  module SharedHelpers
    attr_accessor :gem_loaded

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "Could not locate Gemfile"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

    def env_file
      default_gemfile.dirname.join(".bundle/environment.rb")
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten
      Gem.source_index # ensure RubyGems is fully loaded

     ::Kernel.class_eval do
        private
        def gem(*) ; end
      end

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        gem_bin = File.join(spec.full_gem_path, spec.bindir, exec_name)
        gem_from_path_bin = File.join(File.dirname(spec.loaded_from), spec.bindir, exec_name)
        File.exist?(gem_bin) ? gem_bin : gem_from_path_bin
      end
    end

    extend self
  end
end

module Bundler
  ENV_LOADED   = true
  LOCKED_BY    = '0.9.25'
  FINGERPRINT  = "665da6856f1f8fc463b17d35854fddc34061f0f8"
  HOME         = '/Users/alex/.rvm/gems/ruby-head@heroku/bundler'
  AUTOREQUIRES = {:default=>[["authlogic", false], ["cancan", false], ["haml", false], ["paperclip", false], ["rails", false]], :development=>[["mysql", false], ["sqlite3", true]]}
  SPECS        = [
        {:name=>"rake", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@global/gems/rake-0.8.7/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@global/specifications/rake-0.8.7.gemspec"},
        {:name=>"abstract", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/abstract-1.0.0/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/abstract-1.0.0.gemspec"},
        {:name=>"builder", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/builder-2.1.2/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/builder-2.1.2.gemspec"},
        {:name=>"i18n", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/i18n-0.3.7/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/i18n-0.3.7.gemspec"},
        {:name=>"memcache-client", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/memcache-client-1.8.3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/memcache-client-1.8.3.gemspec"},
        {:name=>"tzinfo", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/tzinfo-0.3.20/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/tzinfo-0.3.20.gemspec"},
        {:name=>"activesupport", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/activesupport-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/activesupport-3.0.0.beta3.gemspec"},
        {:name=>"activemodel", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/activemodel-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/activemodel-3.0.0.beta3.gemspec"},
        {:name=>"erubis", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/erubis-2.6.5/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/erubis-2.6.5.gemspec"},
        {:name=>"rack", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/rack-1.1.0/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/rack-1.1.0.gemspec"},
        {:name=>"rack-mount", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/rack-mount-0.6.3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/rack-mount-0.6.3.gemspec"},
        {:name=>"rack-test", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/rack-test-0.5.3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/rack-test-0.5.3.gemspec"},
        {:name=>"actionpack", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/actionpack-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/actionpack-3.0.0.beta3.gemspec"},
        {:name=>"mime-types", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/mime-types-1.16/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/mime-types-1.16.gemspec"},
        {:name=>"polyglot", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/polyglot-0.3.1/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/polyglot-0.3.1.gemspec"},
        {:name=>"treetop", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/treetop-1.4.5/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/treetop-1.4.5.gemspec"},
        {:name=>"mail", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/mail-2.2.1/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/mail-2.2.1.gemspec"},
        {:name=>"text-hyphen", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@global/gems/text-hyphen-1.0.0/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@global/specifications/text-hyphen-1.0.0.gemspec"},
        {:name=>"text-format", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@global/gems/text-format-1.0.0/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@global/specifications/text-format-1.0.0.gemspec"},
        {:name=>"actionmailer", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/actionmailer-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/actionmailer-3.0.0.beta3.gemspec"},
        {:name=>"arel", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/arel-0.3.3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/arel-0.3.3.gemspec"},
        {:name=>"activerecord", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/activerecord-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/activerecord-3.0.0.beta3.gemspec"},
        {:name=>"activeresource", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/activeresource-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/activeresource-3.0.0.beta3.gemspec"},
        {:name=>"authlogic", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/bundler/gems/authlogic-6baa44cd7023e0828fc87e150aa82c0caeeb7c3d-a087ad0cba3c165ba22fcf176c28b6f7517931e8/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/bundler/gems/authlogic-6baa44cd7023e0828fc87e150aa82c0caeeb7c3d-a087ad0cba3c165ba22fcf176c28b6f7517931e8/authlogic.gemspec"},
        {:name=>"bundler", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/bundler-0.9.25/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/bundler-0.9.25.gemspec"},
        {:name=>"cancan", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/cancan-1.1.1/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/cancan-1.1.1.gemspec"},
        {:name=>"haml", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/haml-3.0.4/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/haml-3.0.4.gemspec"},
        {:name=>"mysql", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/mysql-2.8.1/lib", "/Users/alex/.rvm/gems/ruby-head@heroku/gems/mysql-2.8.1/ext"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/mysql-2.8.1.gemspec"},
        {:name=>"paperclip", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/bundler/gems/paperclip-2340c0629d7570baca067e52b39b3e61243dc478-c285292ee515e0169ebff6f3fa63aec48a383850/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/bundler/gems/paperclip-2340c0629d7570baca067e52b39b3e61243dc478-c285292ee515e0169ebff6f3fa63aec48a383850/paperclip.gemspec"},
        {:name=>"thor", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/thor-0.13.6/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/thor-0.13.6.gemspec"},
        {:name=>"railties", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/railties-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/railties-3.0.0.beta3.gemspec"},
        {:name=>"rails", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/rails-3.0.0.beta3/lib"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/rails-3.0.0.beta3.gemspec"},
        {:name=>"sqlite3-ruby", :load_paths=>["/Users/alex/.rvm/gems/ruby-head@heroku/gems/sqlite3-ruby-1.2.5/lib", "/Users/alex/.rvm/gems/ruby-head@heroku/gems/sqlite3-ruby-1.2.5/ext"], :loaded_from=>"/Users/alex/.rvm/gems/ruby-head@heroku/specifications/sqlite3-ruby-1.2.5.gemspec"},
      ].map do |hash|
    if hash[:virtual_spec]
      spec = eval(hash[:virtual_spec], TOPLEVEL_BINDING, "<virtual spec for '#{hash[:name]}'>")
    else
      dir = File.dirname(hash[:loaded_from])
      spec = Dir.chdir(dir){ eval(File.read(hash[:loaded_from]), TOPLEVEL_BINDING, hash[:loaded_from]) }
    end
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    if spec.loaded_from.include?(HOME)
      Bundler::Specification.from_gemspec(spec)
    else
      spec
    end
  end

  extend SharedHelpers

  def self.configure_gem_path_and_home(specs)
    # Fix paths, so that Gem.source_index and such will work
    paths = specs.map{|s| s.installation_path }
    paths.flatten!; paths.compact!; paths.uniq!; paths.reject!{|p| p.empty? }
    ENV['GEM_PATH'] = paths.join(File::PATH_SEPARATOR)
    ENV['GEM_HOME'] = paths.first
    Gem.clear_paths
  end

  def self.match_fingerprint
    lockfile = File.expand_path('../../Gemfile.lock', __FILE__)
    lock_print = YAML.load(File.read(lockfile))["hash"] if File.exist?(lockfile)
    gem_print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))

    unless gem_print == lock_print
      abort 'Gemfile changed since you last locked. Please run `bundle lock` to relock.'
    end

    unless gem_print == FINGERPRINT
      abort 'Your bundled environment is out of date. Run `bundle install` to regenerate it.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    configure_gem_path_and_home(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      spec.require_paths.each do |path|
        $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
      end
    end
    self
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group.to_sym] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Set up load paths unless this file is being loaded after the Bundler gem
  setup unless defined?(Bundler::GEM_LOADED)
end