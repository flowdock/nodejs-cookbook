# Cookbook Name:: nodejs
# Attributes:: default
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

# Array of versions to be built/installed
default.nodejs[:versions] = [ "0.6.14" ]

# Symlinks to default version will be created under /usr/local/bin
default.nodejs[:default_version] = "0.6.14"
  
# Node versions will be installed under [base_dir]/versions/ subdirectory
default.nodejs[:base_dir] = "/opt/nodejs"
  
# Download base url for the node binary packages, e.g. s3 http endpoint or cloudfront url.
# It will be extended into [base_url]/[distribution codename]/nodejs-[version].tgz
default.nodejs[:base_url] = "http://CHANGEME.cloudfront.net"
