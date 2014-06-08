require 'serverspec'

include Serverspec::Helper::Exec

def os
  backend(Serverspec::Commands::Base).check_os
end

def describe_kernel_parameter(name, value)
  param = linux_kernel_parameter(name)
  describe param do
    it { expect(param.value).to eq(value) }
  end
end
