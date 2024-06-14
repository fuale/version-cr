require "option_parser"

class Version::Cli
  def run : Nil
    OptionParser.parse do |parser|
      parser.banner = <<-HELLO
      Welcome to The Version App! (#{Version::VERSION})

      Usage:
        version [options] [commands]

      Commands:
          changes, changelog#{" " * (33 - 18)}Generate ChangeLog
          bump, up#{" " * (33 - 8)}Bump version

      Options:
      HELLO

      parser.on "-v", "--version", "Show Program Revision Number" do
        puts Version::VERSION
        exit
      end

      parser.on "-h", "--help", "Show Help" do
        puts parser
        exit
      end

      parser.on "--verbose", "Show any errors" do
        Config.verbose = true
      end

      parser.invalid_option do |option_flag|
        STDERR.puts "ERROR: #{option_flag} is not a valid option."
        STDERR.puts parser
        exit(1)
      end

      parser.missing_option do |option_flag|
        STDERR.puts "ERROR: #{option_flag} is not a existing option."
        STDERR.puts parser
        exit(1)
      end
    end

    case ARGV[0]?
    when "changes", "changelog"
      puts Version::ChangeLog.build
    when "bump", "up"
      puts Version::Bumper.bump
    else
      puts "error: no command was given"
    end
  end
end
