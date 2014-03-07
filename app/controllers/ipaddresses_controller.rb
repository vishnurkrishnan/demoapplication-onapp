class IpaddressesController < ApplicationController
  before_action :set_ipaddress, only: [:show, :edit, :update]
  before_action :vm_object!, only: [:index,:new,:getlist]
  before_action :ip_object!, only: [:index,:create]
  before_action :newIP_object!,only: [:destroy_ip]
  # GET /ipaddresses
  # GET /ipaddresses.json
  def index
    #@ipaddresses = Ipaddress.all
    remotevmID = Virtualmachine.find(params[:id])
    @ipaddresses = @vm.show remotevmID.RemoteID

  end

  # GET /ipaddresses/1
  # GET /ipaddresses/1.json
  def show
  end

  # GET /ipaddresses/new
  def new
    @iphash = Hash.new
    @ipaddress = Ipaddress.new
    rid = Virtualmachine.find(params[:id])
    @nwIntDet = @vm.listInt(rid.RemoteID)
    @nwIntDet.each do |a|
     @iphash[a["id"]] = a["label"] 
    end

  end

  # GET /ipaddresses/1/edit
  def edit
  end

  # POST /ipaddresses
  # POST /ipaddresses.json
  def create
    getRemID = Virtualmachine.find(params[:id])
    @ipaddress = Ipaddress.new(ipaddress_params)
    @vmIPjoin_res = @ipobject.addIp(getRemID.RemoteID,params)
    unless @vmIPjoin_res.has_key?("errors")
      #@ipaddress.virtualmachine_id = getRemID.RemoteID
      #p @ipaddress.virtualmachine_id
      #respond_to do |format|
      #  if @ipaddress.save
      #    format.html { redirect_to @ipaddress, notice: 'Ipaddress was successfully created.' }
      #    format.json { render action: 'show', status: :created, location: @ipaddress }
      #  else
      #    format.html { render action: 'new' }
      #    format.json { render json: @ipaddress.errors, status: :unprocessable_entity }
      #  end
      #end
      redirect_to @ipaddress, notice: 'Ipaddress was successfully created.'
    else
     flash.keep[:notice] = "Errors are #{@vmIPjoin_res["errors"]}"
     redirect_to action: :new
    end
  end

  # PATCH/PUT /ipaddresses/1
  # PATCH/PUT /ipaddresses/1.json
  def update
    respond_to do |format|
      if @ipaddress.update(ipaddress_params)
        format.html { redirect_to @ipaddress, notice: 'Ipaddress was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ipaddress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ipaddresses/1
  # DELETE /ipaddresses/1.json
  def destroy
    @ipaddress.destroy
    respond_to do |format|
      format.html { redirect_to ipaddresses_url }
      format.json { head :no_content }
    end
  end


  def destroy_ip
   getRemID = Virtualmachine.find(params[:id])
   p params["token"]
   #@response_dltIP = @newIP.delete(getRemID.RemoteID,params[:token])

  end
  #for Ajax call via getting the unassigned IPs
  def getlist
    @uniphash = Hash.new
    @unUsedIps = @vm.unassigned_ip_addresses(params[:intIDp])
    @unUsedIps.each do |unUsedIps|
      @uniphash[unUsedIps["id"]] = unUsedIps["descriptor"] 
    end
    respond_to do |format|
      format.js
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ipaddress
      @ipaddress = Ipaddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ipaddress_params
      params.require(:ipaddress).permit(:ip_address,:interface,:virtualmachine_id)
    end
end
