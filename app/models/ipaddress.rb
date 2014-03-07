class Ipaddress < ActiveRecord::Base
	belongs_to :virtualmachine_id

	def addIp(getRemoteID,paramsForip)
		p getRemoteID
		p paramsForip["ip_address"]
		params ={

			:ip_address_id  => paramsForip["ip_address"],
			:network_interface_id => paramsForip["ipaddress"]["interface"]
		}
		ip = Squall::IpAddressJoin.new
		ip_response = ip.assign(getRemoteID,params)
		p ip_response
	end
end
