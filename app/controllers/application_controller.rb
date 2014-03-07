class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
 
  def vm_object!
  	@vmUpdate = Virtualmachine.new
  	@vm = Squall::VirtualMachine.new 
  end

  def ip_object!
    @ipobject = Ipaddress.new
  	@ip= Squall::IpAddress.new
  end

  def newIP_object!
    @newIP = Squall::IpAddressJoin.new
  end
end
