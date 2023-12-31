module Twurl
  class AliasesController < AbstractCommandController
    NO_ALIASES_MESSAGE       = "No aliases exist. Set one this way: twurl alias h /1.1/statuses/home_timeline.json"
    NO_PATH_PROVIDED_MESSAGE = "No path was provided to alias. Paths must start with a forward slash (ex. /1.1/statuses/update.json)."
    def dispatch
      case options.subcommands.size
      when 0
        aliases = OAuthClient.rcfile.aliases
        if aliases && !aliases.empty?
          aliases.keys.sort.each do |name|
            CLI.puts "#{name}: #{aliases[name]}"
          end
        else
          CLI.puts NO_ALIASES_MESSAGE
        end
      when 1
        if options.path
          if Twurl::CLI::SUPPORTED_COMMANDS.include?(options.subcommands.first)
            raise Exception, "ERROR: '#{options.subcommands.first}' is reserved for commands. Please use different alias name."
          else
            OAuthClient.rcfile.alias(options.subcommands.first, options.path)
          end
        else
          raise Exception, NO_PATH_PROVIDED_MESSAGE
        end
      end
    end
  end
end
