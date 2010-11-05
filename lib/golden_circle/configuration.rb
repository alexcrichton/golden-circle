module GoldenCircle
  class Configuration # Must be a class for ActiveSupport::Configurable to work
    include ActiveSupport::Configurable

    config.event_date = Time.now
    config.cost_per_student = 4
    config.deadline = Time.now
    config.cutoff_score = {
      'large' => {'wizard' => 20, 'apprentice' => 20},
      'small' => {'wizard' => 20, 'apprentice' => 20}
    }

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

