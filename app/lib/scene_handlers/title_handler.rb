require 'app/lib/input_handler.rb'
require 'app/lib/scene_handlers/game_play_handler.rb'
require 'app/lib/scene_handlers/game_over_handler.rb'

class TitleHandler
  SCENE = 'titles'

  class << self

    def title_tick(args)
      if InputHandler.fire_input?(args)
        args.outputs.sounds << "sounds/game-over.wav"
        args.state.scene = GamePlayHandler::SCENE
        return
      end

      GameOverHandler.load_high_score(args)
      handle_title_labels(args)
    end

    def handle_title_labels(args)
      labels = [
        {
          x: 40,
          y: args.grid.h - 40,
          text: "Target Practice!",
          size_enum: 6,
        },
        {
          x: 40,
          y: args.grid.h - 88,
          text: "Hit the targets!",
        },
        {
          x: 40,
          y: args.grid.h - 120,
          text: "by thewmking",
        },
        {
          x: 40,
          y: 120,
          text: "Arrows or WASD to move | Z or J to fire | gamepad works too",
        },
        {
          x: 40,
          y: 80,
          text: "Fire to start",
          size_enum: 2,
        },
      ]

      labels << {
        x: 260,
        y: args.grid.h - 88,
        text: "Score to beat: #{args.state.high_score}",
      } if args.state.high_score

      args.outputs.labels << labels
    end
  end
end