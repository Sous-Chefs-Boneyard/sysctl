if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :sysctl

  # @example This is an example
  # expect(chef_run.to apply_sysctl('foo')
  #
  # @param [String] resource_name
  # the resource name
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def apply_sysctl(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sysctl, :apply, resource_name)
  end

  def remove_sysctl(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sysctl, :remove, resource_name)
  end

  def save_sysctl(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sysctl, :save, resource_name)
  end
end
