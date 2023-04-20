require 'app/lib/input_handler.rb'
require 'app/lib/game_play_handler.rb'

class GameOverHandler
  HIGH_SCORE_FILE = "high-score.txt"
  SCENE = 'game_over'

  class << self

    def game_over?(args)
      args.state.timer < 0
    end

    def game_over_tick(args)
      handle_high_score(args)
      handle_game_over_labels(args)

      if args.state.timer < -30 && InputHandler.fire_input?(args)
        args.state.scene = GamePlayHandler::SCENE
        $gtk.reset
      end
    end

    def handle_game_over_labels(args)
      labels = [
        {
          x: 40,
          y: args.grid.h - 40,
          text: "Game Over!",
          size_enum: 10,
        },
        {
          x: 40,
          y: args.grid.h - 90,
          text: "Score: #{args.state.score}",
          size_enum: 4,
        },
        {
          x: 40,
          y: args.grid.h - 132,
          text: "Fire to restart",
          size_enum: 2,
        },
        {
          x: 260,
          y: args.grid.h - 90,
          text: args.state.score > args.state.high_score ? 'New high score!' : "Score to beat: #{args.state.high_score}",
          size_enum: 3,
        },
      ]

      args.outputs.labels << labels
    end

    def handle_high_score(args)
      args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i

      if !args.state.saved_high_score && args.state.score > args.state.high_score
        args.gtk.write_file(HIGH_SCORE_FILE, args.state.score.to_s)
        args.state.saved_high_score = true
      end
    end

  end
end