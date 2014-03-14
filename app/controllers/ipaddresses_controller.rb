class IpaddressesController < ApplicationController
  before_action :set_ipaddress, only: [:show, :edit, :update]
  before_action :load_virtualmachine,except: :getlist
  before_action :vm_object!, only: [:index,:new,:getlist]
  before_action :ip_object!, only: [:index,:create,:destroy]
  before_action :newIP_object!,only: [:index,:destroy]
  # GET /ipaddresses
  # GET /ipaddresses.json
  def index
    
    @ip_joins = @ipobject.saveIP(@virtualmachine.RemoteID,@virtualmachine.id)
    @ipaddresses = @virtualmachine.ipaddresses
  end

  # GET /ipaddresses/1
  # GET /ipaddresses/1.json
  def show
  end

  # GET /ipaddresses/new
  def new
    @rid = Virtualmachine.find(params[:virtualmachine_id])
    @ipaddress = Ipaddress.new
    @iphash = Hash.new
    @nwIntDet = @vm.listInt(@rid.RemoteID)
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
    @ipaddress = Ipaddress.new(ipaddress_params)
    @vmIPjoin_res = @ipobject.addIp(@virtualmachine.RemoteID,params)
    unless @vmIPjoin_res.has_key?("errors")
      respond_to do |format|

        format.html { redirect_to virtualmachine_ipaddresses_url, notice: 'Ipaddress was successfully created.' }
      end
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
    @ipaddress = Ipaddress.find(params[:id])
    @ipJoinID = @newIP.list(@virtualmachine.RemoteID).find{|joinipID| joinipID["ip_address_id"] == @ipaddress.ip }  
    @responsedelt = @ipobject.deleteIP(@virtualmachine.RemoteID,@ipJoinID['id'])
    p @responsedelt
    respond_to do |format|
    if @responsedelt.blank?
       @ipaddress.destroy
       format.html { redirect_to [@virtualmachine, @ipaddress],notice: 'IP Address will be delete shortly.' }
       format.json { head :no_content }    
    else
       format.html { redirect_to virtualmachine_ipaddresses_url,notice: "Errors are #{@responsedelt["errors"]}" }
    end
    end
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

    def load_virtualmachine
      @virtualmachine = Virtualmachine.find(params[:virtualmachine_id])
    end

    def set_ipaddress
      @ipaddress = Ipaddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ipaddress_params
      params.require(:ipaddress).permit(:ip_address,:ip,:interface,:virtualmachine_id)
    end
end
