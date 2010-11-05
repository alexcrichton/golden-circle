module GoldenCircle
  class Configuration # Must be a class for ActiveSupport::Configurable to work
    include ActiveSupport::Configurable

    def self.load!
      settings = Setting.all
      settings.each do |setting|
        config[setting.var] = setting.value

        unless GoldenCircle.respond_to?(setting.var)
          GoldenCircle.class.delegate setting.var,
            :to => 'GoldenCircle::Configuration.config'
        end

      end
    end

    def self.save!
      config.each_pair do |var, value|
        s = Setting.find_or_initialize_by :var => var
        s.value = value
        s.save!
      end
    end

  end
end

