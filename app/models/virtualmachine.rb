class Virtualmachine < ActiveRecord::Base
  has_many :ipaddresses
  #validates :Label, presence: true
  #validates :Hostname, presence: true
  #validates :RemoteID, presence: true
  #validates :LabelOS, presence: true 

  #Create VS
	def createVMcall(paramsForvm)     
    params = {
      :template_id =>  paramsForvm["Template"],
      :label =>  paramsForvm["Label"],
      :hostname =>  paramsForvm["Hostname"],
      :memory =>  paramsForvm["Ram"],
      :cpus =>  paramsForvm["CpuCore"],
      :cpu_shares =>  paramsForvm["CpuPrio"],
      :primary_disk_size => paramsForvm["PDSize"] ,
      :swap_disk_size =>  paramsForvm["SDSize"],
      :required_virtual_machine_build => paramsForvm["BVS"],
      :required_automatic_backup => paramsForvm["EAB"],
      :required_virtual_machine_startup => paramsForvm["BootVS"],
      :required_ip_address_assignment => "1",
      :recipe_ids => [
          
    ],
    :custom_recipe_variables => {
     
       
    }
       #licensing_key:   ,
       #hypervisor_group_id:   ,
       #hypervisor_id:   ,
       #initial_root_password:   ,
       #data_store_group_primary_id:   ,
       #primary_disk_min_iops:  ,
       #data_store_group_swap_id:   ,
       #swap_disk_min_iops:   ,
       #primary_network_group_id:   ,
       #selected_ip_address_id:   ,
       #rate_limit:   ,
       #required_ip_address_assignment:   ,
       #required_automatic_backup:   ,
       #required_virtual_machine_build:   ,
       #required_virtual_machine_startup:   ,
       #type_of_format:  ,
       #enable_autoscale:   
}
       params.merge!({:hypervisor_id => paramsForvm["HypervisorID"]}) unless paramsForvm["HypervisorID"].blank?    
       puts ".in create..#{params}"
       vm = Squall::VirtualMachine.new
       vm_response = vm.create params
       #p vm_response["virtual_machine"]["id"]
       #vm_respose_int = vm.createInt(vm_response["virtual_machine"]["id"],{:label => "eth1", :network_join_id => "5", :rate_limit => "0"})
       puts "...response from #{vm_response}"
       #puts "...response from #{vm_respose_int}"
       return vm_response  
	end	
   
  #Update VS 
  def editVMcall(editForvm)
    editid = editForvm["RemoteID"]
    #puts "....id#{newid}"
    paramsedit = {

      label:  editForvm["Label"],
      memory:  editForvm["Ram"],
      cpus:  editForvm["CpuCore"],
      cpu_shares:  editForvm["CpuPrio"],
      custom_recipe_variables: 
      {
            
      }
    }

    p paramsedit
    begin
      vmedit = Squall::VirtualMachine.new
      vmedit_response = vmedit.edit(editid,paramsedit)
      return vmedit_response 
    rescue Exception => e
      flash[:notice] = "Something went wrong #{e.message}"
    end   
  end

  #Build VS
  def buildVMcall(remID,temp_id,bool)
    paramsbuild = {
      :template_id => temp_id    
    }
    paramsbuild.merge!({:required_startup => bool}) unless bool.nil? 
    p paramsbuild
    vmbuild = Squall::VirtualMachine.new
    vmbuild_response = vmbuild.build(remID,paramsbuild)
    return vmbuild_response
  end

  def usageVMcall(idForCpu)
    getRemote = Virtualmachine.find(idForCpu)
    vmusage = Squall::VirtualMachine.new
    vmusage_response = vmusage.cpu_usage(getRemote.RemoteID,Time.now - 1.day,Time.now)
    return vmusage_response
  end
  #Start VS
  def startVMcall(idForStart)
    getRemote = Virtualmachine.find(idForStart)
    vmstart = Squall::VirtualMachine.new
    vmstart_response = vmstart.startup(getRemote.RemoteID)
    return vmstart_response
  end
  
  #Shutdown VS
  def shutdownVMcall(idForShut)
    getRemote = Virtualmachine.find(idForShut)
    vmshut = Squall::VirtualMachine.new
    vmshut_response = vmshut.shutdown(getRemote.RemoteID)
    return vmshut_response
  end
  
  #Reboot VS
  def rebootVMcall(idForBoot)
    getRemote = Virtualmachine.find(idForBoot)
    vmboot = Squall::VirtualMachine.new
    vmboot_response = vmboot.reboot(getRemote.RemoteID)
    return vmboot_response
  end

  #Suspend VS
  def suspendVMcall(idForSuspend)
    getRemote = Virtualmachine.find(idForSuspend)
    vmsuspend = Squall::VirtualMachine.new
    vmsuspend_response = vmsuspend.suspend(getRemote.RemoteID)
    return vmsuspend_response
  end

  #Rebuild VS
  def rebuildVMcall(idForRebuild)
    getRemote = Virtualmachine.find(idForRebuild)
    vmrebuild = Squall::Network.new
    vmrebuild_response = vmrebuild.rebuild(getRemote.RemoteID)
    return vmrebuild_response
  end
    
  #Delete VS
  def deleteVMcall(idForDelt)
    vmdelt = Squall::VirtualMachine.new
    vmdelt_response = vmdelt.delete idForDelt
    return vmdelt_response
  end


end
