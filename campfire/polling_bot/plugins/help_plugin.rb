# Plugin to display available commands for each plugin
class HelpPlugin < Campfire::PollingBot::Plugin
  accepts :text_message, :addressed_to_me => true
  priority 0

  def process(message)
    person = message.person
    case message.command
    when /help(?: (.*))?/i
      bot.say("Oh, too lazy to look at the damn source code? Fine:")
      help_msg = ''
      help = {}

      bot.plugins.each do |plugin|
        begin
          help[plugin.to_s] = plugin.help if plugin.respond_to?(:help)
        rescue Exception => e
          logger.error "Exception: #{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
        end
      end

      if $1
        name = $1
        plugin = help.keys.find{|k| k =~ /#{name}(plugin)?/i }
        help = { plugin => help[plugin] } if plugin
      end

      help.keys.sort.each do |plugin|
        help_msg << "#{plugin}:\n"
        help[plugin].each { |command, description| help_msg << " - #{command}\n     #{description}\n" }
        help_msg << "\n"
      end

      bot.paste(help_msg)
      return HALT
    end
  end

  # return array of available commands and descriptions
  def help
    [['help', "this message"]]
  end
end
