require "facebook/messenger"
require_relative "game/controller"

include Facebook::Messenger

Bot.on :message do |message|
  user_psid = message.sender["id"]
  text = message.quick_reply || message.text

  case text
  when /^(X|O)$/ # user selected x from the choose marker prompt
    Game::Controller.new_game(message, $1).start
  else
    # send_choose_marker_prompt(message)
    Game::Controller.resume_game(message).start(text)
  end
end
