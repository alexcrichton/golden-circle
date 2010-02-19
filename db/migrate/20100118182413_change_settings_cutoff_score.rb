class ChangeSettingsCutoffScore < ActiveRecord::Migration
  def self.up
    Settings.cutoff_score = {'large' => {'apprentice' => '20', 'wizard' => '20'}, 'small' => {'apprentice' => '20', 'wizard' => '20'}}
  end

  def self.down
  end
end
