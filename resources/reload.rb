action :reload do
  if node['init_package'] == 'systemd'
    execute 'reload sysctl via systemd' do
      command '/usr/lib/systemd/systemd-sysctl'
      action :run
    end
  else
    service 'procps' do
      supports restart: true, reload: true, status: false
      action :restart
    end
  end
end
