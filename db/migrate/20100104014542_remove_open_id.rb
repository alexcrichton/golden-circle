class RemoveOpenId < ActiveRecord::Migration
  def self.up
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
    remove_column :schools, :openid_identifier
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
