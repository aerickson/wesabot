# Plugin to make Wes chatty (or annoying)
class KibitzPlugin < Campfire::PollingBot::Plugin
  accepts :text_message, :addressed_to_me => true
  priority -1

  def process(message)
    person = message.person
    case message.command
    when /^\s*$/
      # question questioners, exclaim at exclaimers, dot dotters
      message.body.match(/(\?|\!|\.)$/)
      bot.say(person + $1.to_s)
    when /say\s+(.*)/
      bot.say($1)
    when /^(hey|hi|hello|sup|howdy)/i
      bot.say("#{$1} #{person}")
    when /(^later|(?:good\s*)?bye)/i
      bot.say("#{$1} #{person}")
    when /you rock|awesome|cool/i
      sayings = ["Thanks, #{person}, you're pretty cool yourself.",
                 "I try.",
                 "Aw, shucks. Thanks, #{person}."]
      bot.say_random(sayings)
    when /(^|you|still)\s*there/i, /\byt\b/i
      bot.say_random(%w{Yup y})
    when /(wake up|you awake)/i
      bot.say("Yo.")
    when /zod/i
      bot.say_random [
        "Zod's a wanker.",
        "I'd tell you about Zod, but you wouldn't listen. No one ever does.",
        "somebody send Zod back to the Phantom Zone",
        "Zod and I were friends, once. It all ended one awful night in El Paso over a bottle of shitty scotch and a ten-dollar whore. Christ, those were the days."
      ]
    when /thanks|thank you/i
      bot.say_random ["No problem.", "np", "any time", "that's what I'm here for", "You're welcome."]
    when /^(good\s?night|g'?night)$/
      bot.say_random [
        "see you later, #{person}",
        "later, #{person}",
        "night",
        "goodnight",
        "bye",
        "have a good night"
      ]
    when /^(see you(?: later)?)$/
      bot.say_random [
        "see you later, #{person}",
        "later, #{person}",
        "bye",
        "later",
        "see ya",
      ]
    when /(get|grab|fetch|bring)( me)?( a)? coffee/
      person = ($1 == "me") ? "you" : $1
      does = (person == "you") ? "do you" : "does #{person}"
      boy.say_random [
        "would #{person} like sugar or cream?",
        "how #{does} take it?",
        "coming right up",
        "It is by caffeine alone I set my mind in motion",
        "It is by the beans of Java that thoughts acquire speed",
        "The hands acquire shakes, the shakes become a warning",
        "It is by caffeine alone I set my mind in motion"
      ]
    else
      bot.say_random [
        "I have no idea what you're talking about, #{person}.",
        "eh?",
        "oh, interesting",
        "say more, #{person}",
        "#{person}, you do realize that you're talking to a bot with a very limited vocabulary, don't you?",
        "Whatever, #{person}.",
        "#{bot.other_person(person) || 'Marc'}, tell #{person} to leave me alone.",
        "Not now, #{person}.",
        "brb crying",
        "How do you feel when someone says '#{message.command}' to you, #{person}?"
      ]
    end
  end
end
