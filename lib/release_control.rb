require 'pp'

require 'rubygems'

require 'virtual'; Virtual.activate

require 'packaging/debian/package'
require 'packaging/debian/repository/s3'

require 'release_control/settings'

require 'release_control/repository'
require 'release_control/repository/distribution'
require 'release_control/repository/get'
require 'release_control/repository/get/substitute'
require 'release_control/repository/package'
require 'release_control/repository/transform'

require 'release_control/commands/copy_package'
require 'release_control/commands/copy_package/substitute'

require 'release_control/commands/remove_package'
require 'release_control/commands/remove_package/substitute'

require 'release_control/commands/release'
require 'release_control/commands/release/substitute'
