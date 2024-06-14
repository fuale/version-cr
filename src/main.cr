require "./support/*"
require "./cli"
require "./changelog"
require "./bumper"

module Version
  VERSION = "0.1.0"
end

cli = Version::Cli.new
cli.run
