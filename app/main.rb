require 'app/lib/scene_handlers/game_over_handler.rb'
require 'app/lib/scene_handlers/game_play_handler.rb'
require 'app/lib/scene_handlers/title_handler.rb'

FPS = 60

def tick args
  init_timer(args)

  args.state.scene ||= TitleHandler::SCENE

  case args.state.scene
  when GamePlayHandler::SCENE then GamePlayHandler.game_play_tick(args)
  when GameOverHandler::SCENE then GameOverHandler.game_over_tick(args)
  when TitleHandler::SCENE    then TitleHandler.title_tick(args)
  end

end

def init_timer(args)
  args.state.timer ||= 30 * FPS
  args.state.timer -= 1
end

$gtk.reset