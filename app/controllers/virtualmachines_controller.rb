class VirtualmachinesController < ApplicationController
  before_action :vm_object!, only: [:build,:startup,:shutdown,:reboot,:rebuildnw,:suspend]
  before_action :set_virtualmachine, only: [:show, :edit, :update, :destroy,:shutdown,:reboot,:startup]

  # GET /virtualmachines
  # GET /virtualmachines.json
  def index
    @virtualmachines = Virtualmachine.all

  end

  # GET /virtualmachines/1
  # GET /virtualmachines/1.json
  def show
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
    updateVM = Virtualmachine.new
    #puts "....#{params["virtualmachine"]}"
    @response_edit = updateVM.editVMcall(params["virtualmachine"])
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

  #startup
  def startup
    #startvm = Virtualmachine.new
    @response_start = @vmUpdate.startVMcall(params[:id])
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
    @response_shut = @vmUpdate.shutdownVMcall(params[:id])
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
    @response_reboot = @vmUpdate.rebootVMcall(params[:id])
    unless @response_reboot.has_key?("errors")
     @virtualmachine.BootVS = true
     @virtualmachine.save
     flash.keep[:notice] = "Virtual server will be now started."
    else
     flash.keep[:notice] = "Errors are #{@response_reboot["errors"]}"
    end
    redirect_to :action => :show
  end

  #Rebuild Network
  def rebuildnw
    @response_rebuild = @vmUpdate.rebuildVMcall(params[:id])
    unless @response_rebuild.has_key?("errors")
     flash.keep[:notice] = "Virtual server will be now rebuild."
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
