class CreateVirtualmachines < ActiveRecord::Migration
  def change
    create_table :virtualmachines do |t|	
      t.integer :Template
      t.string  :Label
      t.string  :Hostname
      t.integer :HypervisorZID
      t.integer :HypervisorID
      t.string  :Password
      t.string	:PasswordConfirmation
      t.integer	:Ram
      t.integer :CpuCore
      t.integer	:CpuPrio
      t.integer	:DSpZone
      t.integer	:PDSize
      t.integer	:DSsZone
      t.integer	:SDSize
      t.integer :NetZone
      t.integer :PortSpeed
      t.boolean :EAB ,:default => false
      t.boolean :BVS ,:default => true
      t.boolean :BootVS ,:default => false
      t.integer :RemoteID
      t.string	:LabelOS
      

      t.timestamps
    end
  end
end
