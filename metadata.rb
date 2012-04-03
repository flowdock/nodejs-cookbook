maintainer       "Flowdock Ltd"
maintainer_email "team@flowdock.com"
license          "Apache 2.0"
description      "Installs/Configures nodejs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.6.0"
recipe           "nodejs", "Installs specific nodejs versions from pre-compiled binary packages"
recipe           "nodejs::builder", "Builds the nodejs binary packages"
depends          "build-essential"
