#
# Cookbook Name:: nodejs
# Recipe:: default
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

directory "#{node[:nodejs][:base_dir]}/versions" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

node[:nodejs][:versions].each do |version|
  is_default_version = (node[:nodejs][:default_version] == version)
  node_path = "#{node[:nodejs][:base_dir]}/versions/v#{version}"
  download_url = "#{node[:nodejs][:base_url]}/#{node[:lsb][:codename]}/nodejs-#{version}.tgz"

  remote_file "#{Chef::Config[:file_cache_path]}/nodejs-#{version}.tgz" do
    source download_url
    mode "0644"
    not_if "test -e #{node_path}/bin/node"
  end

  bash "install nodejs-v#{version}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -C / -xzf nodejs-#{version}.tgz
    EOH
    not_if "test -e #{node_path}/bin/node"
  end

  if is_default_version
    bash "set symlinks for default node version (#{version})" do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
        if [ -e #{node_path}/bin/node ]; then
          ln -sf #{node_path}/bin/node /usr/local/bin/node
        fi
        if [ -e #{node_path}/bin/npm ]; then
          ln -sf #{node_path}/bin/npm /usr/local/bin/npm
        fi
        if [ -e #{node_path}/bin/node-waf ]; then
          ln -sf #{node_path}/bin/node-waf /usr/local/bin/node-waf
        fi
      EOH
      not_if "test -e /usr/local/bin/node && test -e /usr/local/bin/npm && test -e /usr/local/bin/node-wah && /usr/local/bin/node -v 2>&1 | grep 'v#{version}'"
    end
  end

end
