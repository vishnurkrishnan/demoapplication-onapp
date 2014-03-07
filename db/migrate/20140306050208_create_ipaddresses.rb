class CreateIpaddresses < ActiveRecord::Migration
  def change
    create_table :ipaddresses do |t|
      t.string :ip_address
      t.string :interface
      t.integer :virtualmachine_id, :null => false
      t.timestamps
    end
  end
end
