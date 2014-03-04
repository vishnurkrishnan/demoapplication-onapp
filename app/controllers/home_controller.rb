class HomeController < ApplicationController
  def index
  	vm = Squall::VirtualMachine.new
    puts "...#{vm.list}"
  end
end
