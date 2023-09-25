require 'app/lib/input_handler.rb'
require 'app/lib/player_handler.rb'
require 'app/lib/target_handler.rb'
require 'app/lib/scene_handlers/game_play_handler.rb'
require 'app/lib/scene_handlers/game_over_handler.rb'

class TitleHandler
  SCENE = 'titles'

  class << self

    def title_tick(args)
      if InputHandler.fire_input?(args)
        args.outputs.sounds << "sounds/game-over.wav" unless GamePlayHandler.muted?
        args.state.scene = GamePlayHandler::SCENE
        return
      end

      GameOverHandler.load_high_score(args)
      handle_title_labels(args)
      handle_dragon_select(args)
      handle_powerups(args)
      handle_lines(args)
      render(args)
    end

    def handle_lines(args)
      args.outputs.lines << [
        {
          x: 60,
          y: 365,
          x2: 450,
          y2: 365,
        },
        {
          x: 60,
          y: 250,
          x2: 450,
          y2: 250,
        }
      ]
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
          y: args.grid.h - 160,
          text: "Controls: Arrows or WASD to move | Z or J to fire | Gamepad",
        },
        {
          x: 40,
          y: 500,
          text: "Look out for powerups! (They stack!)",
        },
        {
          x: 60,
          y: 450,
          text: "Flamethrower:",
        },
        {
          x: 60,
          y: 405,
          w: 100,
          text: "Hold Z for a continuous stream of fire",
        },
        {
          x: 60,
          y: 330,
          text: "Fire blast:",
        },
        {
          x: 60,
          y: 290,
          w: 100,
          text: "Shoot 3 fireballs at once.",
        },
        {
          x: 60,
          y: 215,
          text: "Blue flame:",
        },
        {
          x: 60,
          y: 170,
          w: 100,
          text: "Fireballs won't disappear after hitting a target",
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
      args.state.dragon ||= {
        x: 780,
        y: 340,
        w: 200,
        h: 160,
        source_x: 0,
        source_y: 0,
        source_w: 100,
        source_h: 80,
      }

      handle_color_index(args)

      args.state.dragon.variant = PlayerHandler::DRAGON_VARIANTS[args.state.color_index]

      if PlayerHandler::SHEET_VARIANTS.include? args.state.dragon.variant
        animate_dragon_sheet(args) 
      else
        animate_dragon(args)
      end

    end

    def handle_color_index(args)
      args.state.color_index ||= 0
      args.state.color_index -= 1 if InputHandler.key_up_left?(args)
      args.state.color_index += 1 if InputHandler.key_up_right?(args)
      args.state.color_index = 0 if args.state.color_index > (PlayerHandler::DRAGON_VARIANTS.length - 1)
      args.state.color_index = PlayerHandler::DRAGON_VARIANTS.length - 1 if args.state.color_index < 0
    end

    def animate_dragon(args)
      sprite_index = 0.frame_index(count: 6, hold_for: 8, repeat: true)
      args.state.dragon.path = "sprites/dragons/dragon-#{args.state.dragon.variant}-#{sprite_index}.png"
    end

    def handle_powerups(args)
      args.state.powerups = [
        TargetHandler.gen_target_powerup(args,
          powerup: TargetHandler::POWERUP_FIRE_BLAST,
          x: 200,
          y: 290,
        ),
        TargetHandler.gen_target_powerup(args,
          powerup: TargetHandler::POWERUP_FLAMETHROWER,
          x: 200,
          y: 410,
        ),
        TargetHandler.gen_target_powerup(args,
          powerup: TargetHandler::POWERUP_BLUE_FLAME,
          x: 200,
          y: 175,
        ),
      ]
      animate_powerups(args)
    end

    def animate_powerups(args)
      args.state.powerups.each do |t|
        sprite_index = 0.frame_index(count: 2, hold_for: 8, repeat: true)
        t.path = "sprites/powerups/#{t.powerup}-#{sprite_index}.png"
      end
    end

    # unused
    # def animate_dragon_sheet(args)
    #   args.state.dragon.path ||= "sprites/dragons/dragon-#{args.state.dragon.variant}-sheet.png"
    #   args.state.dragon.source_x = args.state.dragon.source_w * 0.frame_index(count: 6, hold_for: 8, repeat: true)
    # end

    def render(args)
      args.outputs.sprites << [
        args.state.dragon,
        args.state.powerups,
      ]
    end
  end
end