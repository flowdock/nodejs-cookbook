#
# Cookbook Name:: nodejs
# Recipe:: builder
#
# Copyright 2012 Flowdock Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

package "libssl-dev"
package "curl"

%w(scripts env).each do |dir|
  directory "#{node[:nodejs][:base_dir]}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
    recursive true
  end
end

%w(package_node s3).each do |script|
  template "#{node[:nodejs][:base_dir]}/scripts/#{script}" do
    source "#{script}.erb"
    owner "root"
    group "root"
    mode "0755"
  end
end

nodejs_aws = data_bag_item('nodejs', 'aws')

%w(aws_id aws_secret s3_bucket).each do |envvar|
  template "#{node[:nodejs][:base_dir]}/env/#{envvar.upcase}" do
    source "envvar.erb"
    mode "0640"
    variables(:value => nodejs_aws[envvar])
  end
end

node[:nodejs][:versions].each do |version|
  bash "build node-#{version}" do
    code <<-EOH
      envdir #{node[:nodejs][:base_dir]}/env #{node[:nodejs][:base_dir]}/scripts/package_node #{version} && touch #{node[:nodejs][:base_dir]}/.built-#{version}
    EOH
    not_if "test -f #{node[:nodejs][:base_dir]}/.built-#{version}"
  end
end


