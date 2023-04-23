require 'app/lib/scene_handlers/game_over_handler.rb'
require 'app/lib/scene_handlers/game_play_handler.rb'
require 'app/lib/scene_handlers/title_handler.rb'

FPS = 60

def tick args

  args.state.scene ||= TitleHandler::SCENE
  args.state.play ||= true unless args.state.play == false

  case args.state.scene
  when GamePlayHandler::SCENE then GamePlayHandler.game_play_tick(args)
  when GameOverHandler::SCENE then GameOverHandler.game_over_tick(args)
  when TitleHandler::SCENE    then TitleHandler.title_tick(args)
  end

end

$gtk.reset