::Chef::Recipe.send(:include, SysctlCookbook::SysctlHelpers::Param)

coerce_attributes(node['sysctl']['params']).each do |x|
  k, v = x.split('=')
  sysctl_param k do
    value v
  end
end if node['sysctl']['params']
