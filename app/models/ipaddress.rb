class Ipaddress < ActiveRecord::Base
	belongs_to :virtualmachine

	def saveIP(remoteID,id)
     forJoinIP = Squall::IpAddressJoin.new
     @joinIPs = forJoinIP.list remoteID
     	@joinIPs.each do |joinip|
     	  @interfaceID = joinip["network_interface_id"]
     		@findIP = Ipaddress.where(ip_address: joinip["ip_address"]["address"])
		  	if @findIP.blank?
     		   @newipdb = Ipaddress.new
 			   @newipdb.ip_address = joinip["ip_address"]["address"]
 			   @newipdb.ip = joinip["ip_address"]["id"]
 			   @newipdb.interface = @interfaceID
 			   @newipdb.virtualmachine_id = id
 			   @newipdb.save
 		  	end	    
	    end
	end

	def addIp(remoteID,paramsForip)
		params ={

			:ip_address_id  => paramsForip["ip_address"],
			:network_interface_id => paramsForip["ipaddress"]["interface"]
		}
		ip = Squall::IpAddressJoin.new
		ip_responses = ip.assign(remoteID,params)
    	return ip_responses
	end	

	def deleteIP(deltVM_id,deltIP_id)
		deltIP = Squall::IpAddressJoin.new
		@deltIP_response = deltIP.delete(deltVM_id,deltIP_id)
		return @deltIP_response
	end
end
