class AddSettingsCutoffScore < ActiveRecord::Migration
  def self.up
    Settings.cutoff_score = 20
  end

  def self.down
  end
end
