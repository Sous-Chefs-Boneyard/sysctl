if defined?(ChefSpec)
  ChefSpec.define_matcher :sysctl_param

  def apply_sysctl_param(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sysctl_param, :apply, resource_name)
  end

  def remove_sysctl_param(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sysctl_param, :remove, resource_name)
  end
end
