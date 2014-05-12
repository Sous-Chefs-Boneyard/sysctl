require 'serverspec'

include Serverspec::Helper::Exec

def os
  backend(Serverspec::Commands::Base).check_os
end
