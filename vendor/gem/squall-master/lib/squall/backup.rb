module Squall
  # OnApp Backup
  class Backup < Base
    
    # Returns list of all Backups belonging to a VM
    def list(virtual_machine_id)
      req = request(:get, "/virtual_machines/#{virtual_machine_id}/backups.json")
      req.collect { |backup| backup['backup'] }
    end
    
    # Returns a Hash for a given backup
    def show(backup_id)
      response = request(:get, "/backups/#{backup_id}.json")
      response.first[1]
    end
    
    # Create a new backup of specified disk
    def create(disk_id)
      req = request(:post, "/settings/disks/#{disk_id}/backups.json")
      req.first[1]
    end
    
    # Enable autobackups for a disk
    def enable_autobackup(disk_id)
      req = request(:post, "/settings/disks/#{disk_id}/autobackup_enable.json")
      req.first[1]
    end
    
    # Disable autobackups for a disk
    def disable_autobackup(disk_id)
      req = request(:post, "/settings/disks/#{disk_id}/autobackup_disable.json")
      req.first[1]
    end
    
    # Delete a backup
    def delete(id)
      request(:delete, "/backups/#{id}.json")
    end
    
    # Restore a VM with its backup
    def restore(id)
      request(:post, "/backups/#{id}/restore.json")
    end
    
    # Convert a backup to a template
    def convert(id, options = {})
      required = [:label]
      optional = []
      params.required(required).accepts(optional).validate! options
      response = request(:post, "/backups/#{id}/convert.json", default_params(options))
      response.first[1]
    end
  end
end