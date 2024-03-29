require 'app/lib/target_handler.rb'
require 'app/lib/music_handler.rb'
require 'app/lib/cloud_handler.rb'
require 'app/lib/background_handler.rb'
require 'app/lib/fireball_handler.rb'
require 'app/lib/input_handler.rb'
require 'app/lib/player_handler.rb'
require 'app/lib/explosion_handler.rb'
require 'app/lib/scene_handlers/game_over_handler.rb'

class GamePlayHandler
  SCENE = 'game_play'
  FPS = 60
  COLOR_WHITE = {
    r: 255,
    g: 255,
    b: 255,
  }
  COLOR_BLACK = {
    r: 0,
    g: 0,
    b: 0,
  }

  # TODO: add checkpoints to increase game time
  # TODO: add baddies, health, damage counters
  GAME_TIME = 30

  GLOBAL_MUTE = false

  class << self

    def muted?
      GLOBAL_MUTE
    end

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
      args.state.timer ||= GAME_TIME * FPS
      args.state.timer -= 1 unless args.state.play == false
    end

    def init_gameplay(args)
      MusicHandler.start_music(args)
      PlayerHandler.init_player(args)

      BackgroundHandler.init(args)
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
        args.state.backgrounds,
        args.state.clouds,
        args.state.player,
        args.state.fireballs,
        args.state.targets,
        args.state.explosions,
        args.state.sparkles,
      ]

      render_top_labels(args)
      render_powerup_labels(args)
      render_pause_overlay(args) if !args.state.play
    end

    def update_animations(args)
      BackgroundHandler.manage_backgrounds(args)
      FireballHandler.manage_fireballs(args)
      CloudHandler.manage_clouds(args)
      TargetHandler.manage_targets(args)
      ExplosionHandler.manage_explosions(args)
      ExplosionHandler.manage_sparkles(args)
    end

    # TODO: DRY!
    def render_top_labels(args)
      size_enum = 4
      score_text = "Score: #{args.state.score}"
      score_w, score_h = args.gtk.calcstringbox score_text, size_enum

      # score background
      args.outputs.primitives << {
        x: 0,
        y: args.grid.h - 100,
        w: score_w + 100,
        h: 100,
        **COLOR_BLACK,
        a: 175,
      }.solid!

      # score label
      args.outputs.labels << {
        x: 40,
        y: args.grid.h - 40,
        text: score_text,
        size_enum: size_enum,
        **COLOR_WHITE,
      }

      timer_text = "Timer: #{(args.state.timer / FPS).round}s"
      timer_w, timer_h = args.gtk.calcstringbox timer_text, size_enum

      # timer background
      timer_bck_w = timer_w + 100
      args.outputs.primitives << {
        x: args.grid.w - timer_bck_w,
        y: args.grid.h - 100,
        w: timer_bck_w,
        h: 100,
        **COLOR_BLACK,
        a: 175,
      }.solid!

      # timer label
      args.outputs.labels << {
        x: args.grid.w - 40,
        y: args.grid.h - 40,
        text: timer_text,
        size_enum: 4,
        alignment_enum: 2,
        **COLOR_WHITE,
      }
    end

    # TODO: render these as the icon instead of text
    def render_powerup_labels(args)
      active_timers = PlayerHandler.active_timers(args)

      args.outputs.primitives << {
        x: 0,
        y: 0,
        w: 600,
        h: active_timers.length * 40 + 5,
        **COLOR_BLACK,
        a: 175,
      }.solid! unless active_timers.empty?

      label_heights = [40, 72, 105]

      active_timers&.each_with_index do |t, idx|
        args.outputs.labels << {
          x: 40,
          y: label_heights.slice(idx),
          text: "#{t[:text]} Time left: #{(args.state.player[t[:timer]] / FPS).round}s",
          size_enum: 4,
          **COLOR_WHITE,
        }
      end
    end

    def render_pause_overlay(args)
      args.outputs.labels << {
        x: (args.grid.w / 2) - 80,
        y: args.grid.h / 2,
        text: "Game paused",
        size_enum: 4,
        **COLOR_BLACK,
      }

      args.outputs.primitives << {
        x: 0,
        y: 0,
        w: args.grid.w,
        h: args.grid.h,
        **COLOR_WHITE,
        a: 220,
      }.solid!
    end

  end
end
