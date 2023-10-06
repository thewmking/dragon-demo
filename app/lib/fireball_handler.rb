require 'app/lib/explosion_handler.rb'
require 'app/lib/player_handler.rb'
require 'app/lib/target_handler.rb'
require 'app/lib/scene_handlers/game_play_handler.rb'

class FireballHandler
  class << self

    TRAJECTORY_RIGHT = 'right'
    TRAJECTORY_DOWN  = 'down'
    TRAJECTORY_UP    = 'up'

    def init(args)
      args.state.fireballs ||= []
      animate_fireballs(args)
    end

    def spawn_multiple(args)
      spawn_fireball(args, trajectory: TRAJECTORY_RIGHT)
      spawn_fireball(args, trajectory: TRAJECTORY_DOWN)
      spawn_fireball(args, trajectory: TRAJECTORY_UP)
    end

    def spawn_fireball(args, trajectory: TRAJECTORY_RIGHT)
      # TODO: smooth out multiples happening at once
      args.outputs.sounds << "sounds/fireball.wav" unless GamePlayHandler.muted?

      args.state.fireballs << fireball_init_obj(args, trajectory)
    end

    def fireball_init_obj(args, trajectory)
      is_blue = args.state.player.blue_flame_timer > 0
      {
        x: args.state.player.x + args.state.player.w - 12,
        y: args.state.player.y + 10,
        w: 57,
        h: 31,
        path: "sprites/fire/#{path_color(is_blue)}-0.png",
        trajectory: trajectory,
        is_blue: is_blue,
      }
    end

    def animate_fireballs(args)
      return unless args.state.play
      args.state.fireballs.each do |f|
        sprite_index = 0.frame_index(count: 7, hold_for: 8, repeat: true)
        f.path = "sprites/fire/#{path_color(f.is_blue)}-#{sprite_index}.png"
      end
    end

    def manage_fireballs(args)
      return unless args.state.play
      deads = 0
      args.state.fireballs.each do |fireball|
        fireball.x += 15
        fireball.y -= 5 if fireball.trajectory == TRAJECTORY_DOWN
        fireball.y += 5 if fireball.trajectory == TRAJECTORY_UP

        if (fireball.x > args.grid.w) || (fireball.y > args.grid.h) || (fireball.y < 0)
          fireball.dead = true
          next
        end

        args.state.targets.each do |target|
          next if target.x > args.grid.w
          if args.geometry.intersect_rect?(target, fireball)
            args.outputs.sounds << "sounds/target.wav" unless GamePlayHandler.muted?
            target.dead = true
            fireball.dead = true unless fireball.is_blue

            if target.powerup
              ExplosionHandler.spawn_sparkle(args, target)
              powerup_timer = TargetHandler::POWERUP_TIMER_MAP[target.powerup][:timer]
              PlayerHandler.enable_powerup(args, powerup_timer)
            else
              ex_color = fireball.is_blue ? 'blue' : nil
              ExplosionHandler.spawn_explosion(args, target, ex_color)
              args.state.score += 1 unless target.powerup
            end

            deads += 1
          end
        end
      end

      args.state.targets.reject! { |t| t.dead }
      args.state.fireballs.reject! { |t| t.dead }

      deads.times do
        TargetHandler.spawn_target(args)
      end
    end

    def path_color(is_blue=false)
      is_blue ? 'fireball-blue' : 'fireball'
    end

  end
end
