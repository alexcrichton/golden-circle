module Acts 
  module Slug

    def self.append_features(base)
      super
      base.extend(ClassMethods)
#      base.send(:include, InstanceMethods)
#      puts base
    end

    module ClassMethods
      # Generates a URL slug based on provided fields and adds <tt>before_validation</tt> callbacks.
      # The URL slug is updated as the record is updated.
      #
      #   class Page < ActiveRecord::Base
      #     acts_as_slug :source, :target => :slug
      #   end
      #
      # Parameters:
      # * <tt>source</tt> - specifies the column name used to generate the URL slug (default <tt>:name</tt>)
      #
      # Configuration options:
      # * <tt>target</tt> - specifies the column name used to store the URL slug (default <tt>:slug</tt>)
      #
      def acts_as_slug(*args)
        options = {:target => 'slug'}.merge(args.extract_options!)
        options[:source] ||= (args[0] || :name)
        write_inheritable_attribute(:acts_as_slug_options, options)
        class_eval do
          include InstanceMethods

          attr_protected :slug
          
          before_validation :create_slug
          validates_presence_of :slug
          validates_uniqueness_of :slug, :if => :slug_changed?, :message => "has been taken. Please change the #{options[:source]}"
        end
      end
    end

    # Adds instance methods.
    module InstanceMethods

      def slug_source_column
        self.class.read_inheritable_attribute(:acts_as_slug_options)[:source]
      end

      def slug_target_column
        self.class.read_inheritable_attribute(:acts_as_slug_options)[:target]
      end

      def to_param
        self[slug_target_column]
      end

      private
      def create_slug
        self[slug_target_column] = self[slug_source_column].to_s.parameterize
      end
    end
  end
end

