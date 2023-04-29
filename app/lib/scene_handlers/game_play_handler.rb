require 'app/lib/music_handler.rb'
require 'app/lib/cloud_handler.rb'
require 'app/lib/fireball_handler.rb'
require 'app/lib/input_handler.rb'
require 'app/lib/player_handler.rb'
require 'app/lib/explosion_handler.rb'
require 'app/lib/scene_handlers/game_over_handler.rb'

class GamePlayHandler
  SCENE = 'game_play'
  FPS = 60

  class << self

    def game_play_tick args
      init_timer(args)

      if args.state.timer < 0
        args.state.player.flame_thrower_timer = 0
        args.state.player.fire_blast_timer = 0
        MusicHandler.stop_music(args)
        MusicHandler.game_over_sound(args)
        args.state.scene = GameOverHandler::SCENE
        return
      end

      init_gameplay(args)
      update_animations(args)
      render(args)
    end

    def init_timer(args)
      args.state.timer ||= 30 * FPS
      args.state.timer -= 1 unless args.state.play == false
    end

    def init_gameplay(args)
      MusicHandler.start_music(args)
      PlayerHandler.init_player(args)

      FireballHandler.init(args)
      TargetHandler.init(args) 
      CloudHandler.init(args) 
      ExplosionHandler.init(args)

      InputHandler.parse_directional_input(args)
      PlayerHandler.enforce_boundaries(args)
      InputHandler.handle_command_input(args)
    end

    def render(args)
      args.outputs.solids << {
        x: 0,
        y: 0,
        w: args.grid.w,
        h: args.grid.h,
        r: 92,
        g: 120,
        b: 230,
      }

      args.outputs.sprites << [
        args.state.clouds,
        args.state.player,
        args.state.fireballs,
        args.state.targets,
        args.state.explosions,
      ]

      args.outputs.labels << {
        x: 40,
        y: args.grid.h - 40,
        text: "Score: #{args.state.score}",
        size_enum: 4,
      }

      args.outputs.labels << {
        x: args.grid.w - 40,
        y: args.grid.h - 40,
        text: "Timer: #{(args.state.timer / FPS).round}s",
        size_enum: 4,
        alignment_enum: 2,
      }

      args.outputs.labels << {
        x: (args.grid.w / 2) - 80,
        y: args.grid.h / 2,
        text: "Game paused",
        size_enum: 4,
      } if !args.state.play

      args.outputs.labels << {
        x: 20,
        y: 100,
        text: "HOLD Z FOR FLAMETHROWER! Time left: #{(args.state.player.flame_thrower_timer / FPS).round}s",
        size_enum: 4,
      } if args.state.player.flame_thrower_timer > 0

      args.outputs.labels << {
        x: 20,
        y: 70,
        text: "FIRE BLAST ENGAGED! Time left: #{(args.state.player.fire_blast_timer / FPS).round}s",
        size_enum: 4,
      } if args.state.player.fire_blast_timer > 0
    end

    def update_animations(args)
      FireballHandler.manage_fireballs(args)
      CloudHandler.manage_clouds(args)
      TargetHandler.manage_targets(args)
      ExplosionHandler.manage_explosions(args)
    end

  end
end