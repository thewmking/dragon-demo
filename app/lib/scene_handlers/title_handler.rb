require 'app/lib/input_handler.rb'
require 'app/lib/player_handler.rb'
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
      handle_dragon_select(args)
      render(args)
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
        {
          x: 770,
          y: 550,
          text: "Choose your dragon:",
          size_enum: 2,
        },
        {
          x: 700,
          y: 430,
          text: "<",
          size_enum: 10,
        },
        {
          x: 1050,
          y: 430,
          text: ">",
          size_enum: 10,
        },
        {
          x: 745,
          y: 300,
          text: "Use arrow keys to change",
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

    def handle_dragon_select(args)
      args.state.dragon = {
        x: 780,
        y: 340,
        w: 200,
        h: 160,
      }

      handle_color_index(args)

      args.state.dragon.variant = PlayerHandler::DRAGON_VARIANTS[args.state.color_index]
      sprite_index = 0.frame_index(count: 6, hold_for: 8, repeat: true)
      args.state.dragon.path = "sprites/dragons/dragon-#{args.state.dragon.variant}-#{sprite_index}.png"
    end

    def handle_color_index(args)
      args.state.color_index ||= 0
      args.state.color_index -= 1 if InputHandler.key_up_left?(args)
      args.state.color_index += 1 if InputHandler.key_up_right?(args)
      args.state.color_index = 0 if args.state.color_index > (PlayerHandler::DRAGON_VARIANTS.length - 1)
      args.state.color_index = PlayerHandler::DRAGON_VARIANTS.length - 1 if args.state.color_index < 0
    end

    def render(args)
      args.outputs.sprites << [
        args.state.dragon,
      ]
    end
  end
end