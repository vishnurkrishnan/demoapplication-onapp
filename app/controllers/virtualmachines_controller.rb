require 'googlecharts'
require 'gchart'
class VirtualmachinesController < ApplicationController
  before_action :newbackup_object!, only: [:backups]
  before_action :vm_object!, only: [:update,:show,:build,:startup,:shutdown,:reboot,:rebuildnw,:suspend,:cpuusage]
  before_action :set_virtualmachine, only: [:rebuildnw,:cpuusage,:show, :edit, :update, :destroy,:shutdown,:reboot,:startup,:ip_addresses,:backups]

  # GET /virtualmachines
  # GET /virtualmachines.json
  def index

    @virtualmachines = Virtualmachine.all

  end

  # GET /virtualmachines/1
  # GET /virtualmachines/1.json
  def show
    @bandwidthM = @vm.show(@virtualmachine.RemoteID).select{|bandwidth| bandwidth["monthly_bandwidth_used"]}
    @allIps = Ipaddress.joins(:virtualmachine).select{|ip| ip["ip_address"] }

  end

  # GET /virtualmachines/new
  def new  
    @virtualmachine = Virtualmachine.new
    @tHash = Hash.new
    vm = Squall::Template.new
    @temparray = vm.list 
    @temparray.each do |temparray|
      @tHash[temparray["id"]] = temparray["label"]
    end
  end

  # GET /virtualmachines/1/edit
  def edit
  end

  # POST /virtualmachines
  # POST /virtualmachines.json
  def create
    @virtualmachine = Virtualmachine.new(virtualmachine_params)     
    #vm = Virtualmachine.new
    @response = @virtualmachine.createVMcall(params["virtualmachine"])
    unless @response.has_key?("errors")
      @virtualmachine.RemoteID = @response["virtual_machine"]["id"]
      @virtualmachine.LabelOS =  @response["virtual_machine"]["template_label"] 
      respond_to do |format|
       if @virtualmachine.save
        format.html { redirect_to @virtualmachine, notice: 'Virtualmachine was successfully created.' }
        format.json { render action: 'show', status: :created, location: @virtualmachine }
       else
        format.html { render action: 'new' }
        format.json { render json: @virtualmachine.errors, status: :unprocessable_entity }
       end
      end
    else
      flash.keep[:notice] = "Errors are #{@response["errors"]}"
      redirect_to action: :index
    end
  end

  # PATCH/PUT /virtualmachines/1
  # PATCH/PUT /virtualmachines/1.json
  def update
    @response_edit = @vmUpdate.editVMcall(params["virtualmachine"])
    p @response_edit
    respond_to do |format|
      if @virtualmachine.update(virtualmachine_params)
        format.html { redirect_to @virtualmachine, notice: 'Virtualmachine was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @virtualmachine.errors, status: :unprocessable_entity }
      end
    end
  end

  #Cpu Usage
  def cpuusage
    cpuArray = Array.new
    dateArray = Array.new
    @cpu_usageres = @vmUpdate.usageVMcall(@virtualmachine.RemoteID)
    @cpu_usageres.each do |u|
      cpuArray.push(u['cpu_time'])
      dateArray.push(Time.parse(u['created_at']).in_time_zone.strftime("%d/%m %H:%M"))
    end
    @chart = Gchart.line(:size => '700x400', 
          :title => 'CPU Usage(Cores) Hourly', :title_color => 'FF0000', :title_size => '20',
          :data => cpuArray ,
          :axis_with_labels => ['x', 'y'], 
          :axis_labels => [dateArray], 
          :axis_range => [cpuArray, dateArray])
  end

  #Backups
  def backups
    @disk_response = @disk.vm_disk_list(@virtualmachine.RemoteID).find{|disk| disk["primary"] == true}
    @backup_response = @backup.create(@disk_response['id'])
    #unless @backup_response.has_key?("errors")
      flash[:notice] = @backup_response
    #else
      #flash.keep[:notice] = "Errors are #{@backup_response["errors"]}"
    #end 
    p @backup_response
  end

  #startup
  def startup
    #startvm = Virtualmachine.new
    @response_start = @vmUpdate.startVMcall(@virtualmachine.RemoteID)
    unless @response_start.has_key?("errors")
     @virtualmachine.BootVS = true
     @virtualmachine.save
     flash.keep[:notice] = "Virtual server will be now started."
    else
     flash.keep[:notice] = "Errors are #{@response_start["errors"]}"
    end
     redirect_to :action => :show
  end

  #ShutDown
  def shutdown
    #shutVM = Virtualmachine.new  
    @response_shut = @vmUpdate.shutdownVMcall(@virtualmachine.RemoteID)
    unless @response_shut.has_key?("errors")
     @virtualmachine.BootVS = false
     @virtualmachine.save
     flash.keep[:notice] = "Virtual server will be shut down shortly."
    else
     flash.keep[:notice] = "Errors are #{@response_shut["errors"]}"
    end
    redirect_to :action => :show

  end

  #Reboot
  def reboot
    #rebootVM = Virtualmachine.new
    @response_reboot = @vmUpdate.rebootVMcall(@virtualmachine.RemoteID)
    unless @response_reboot.has_key?("errors")
     @virtualmachine.BootVS = true
     @virtualmachine.save
     flash.keep[:notice] = "Virtual server will be now reboot."
    else
     flash.keep[:notice] = "Errors are #{@response_reboot["errors"]}"
    end
    redirect_to :action => :show
  end


  #Rebuild Network
  def rebuildnw
    @response_rebuild = @vmUpdate.rebuildVMcall(@virtualmachine.RemoteID)
    unless @response_rebuild.has_key?("errors")
     flash.keep[:notice] = "Network interface will be rebuilt for this Virtual server"
    else
     flash.keep[:notice] = "Errors are #{@@response_rebuild["errors"]}"
    end
    redirect_to :action => :show
  end

  # DELETE /virtualmachines/1
  # DELETE /virtualmachines/1.json
  def destroy
    deleteVm = Virtualmachine.new
    @response_del = deleteVm.deleteVMcall(@virtualmachine.RemoteID)
    @virtualmachine.destroy
    respond_to do |format|
      format.html { redirect_to virtualmachines_url,notice: 'Virtual server will be delete shortly.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtualmachine
      @virtualmachine = Virtualmachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def virtualmachine_params
      params.require(:virtualmachine).permit(:Template, :Label,:Hostname, :HypervisorZID,
        :HypervisorID, :Password,:PasswordConfirmation, :Ram,:CpuCore,:CpuPrio, :DSpZone,:PDSize, :DSsZone,:SDSize, :NetZone,:PortSpeed, :EAB,:BVS,:BootVS,:RemoteID,:LabelOS)
    end
end
