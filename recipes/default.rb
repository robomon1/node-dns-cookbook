aws_creds = Chef::EncryptedDataBagItem.load("aws_creds", node.chef_environment)

unless node['elastic_ip'].empty?
  include_recipe "aws"
  Chef::Log.info "Associating #{node.name} with elastic IP #{node['elastic_ip']}"
  aws_elastic_ip "node_elastic_ip" do
    ip node['elastic_ip']

    aws_access_key aws_creds['access_key_id']
    aws_secret_access_key aws_creds['secret_access_key']

    action :associate
  end
end

if node['cloud'] && node['route53'] && node['route53']['zone_id']
  include_recipe "route53"
  unless node['cloud']['public_ipv4'].nil? || node['cloud']['public_ipv4'].empty?
    route53_record "node_hostname" do
      name "#{node.name}.#{node['set_domain']}"
      value node['cloud']['public_ipv4']
      type "A"
      zone_id node['route53']['zone_id']

      aws_access_key_id aws_creds['access_key_id']
      aws_secret_access_key aws_creds['secret_access_key']

      action :create
    end
  end

  unless node['cloud']['local_ipv4'].nil? || node['cloud']['local_ipv4'].empty?
    route53_record "node_internal_hostname" do
      name "#{node.name}-int.#{node['set_domain']}"
      value node['cloud']['local_ipv4']
      type "A"
      zone_id node['route53']['zone_id']

      aws_access_key_id aws_creds['access_key_id']
      aws_secret_access_key aws_creds['secret_access_key']

      action :create
    end
  end
end
