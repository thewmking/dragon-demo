require 'app/lib/game_over_handler.rb'
require 'app/lib/game_play_handler.rb'

FPS = 60

def tick args
  init_timer(args)

  args.state.scene ||= GamePlayHandler::SCENE

  case args.state.scene
  when GamePlayHandler::SCENE then GamePlayHandler.game_play_tick(args)
  when GameOverHandler::SCENE then GameOverHandler.game_over_tick(args)
  end

end

def init_timer(args)
  args.state.timer ||= 5 * FPS
  args.state.timer -= 1
end

$gtk.reset