require 'app/lib/explosion_handler.rb'
require 'app/lib/player_handler.rb'
require 'app/lib/target_handler.rb'

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
      args.outputs.sounds << "sounds/fireball.wav"
      args.state.fireballs << {
        x: args.state.player.x + args.state.player.w - 12,
        y: args.state.player.y + 10,
        w: 57,
        h: 31,
        path: 'sprites/fire/fireball-0.png',
        trajectory: trajectory,
      }
    end

    def animate_fireballs(args)
      return unless args.state.play
      args.state.fireballs.each do |f|
        sprite_index = 0.frame_index(count: 7, hold_for: 8, repeat: true)
        f.path = "sprites/fire/fireball-#{sprite_index}.png"
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
            args.outputs.sounds << "sounds/target.wav"
            fireball.dead, target.dead = true, true

            # TODO: sparkle explosion on powerup hit
            ExplosionHandler.spawn_explosion(args, target)
            PlayerHandler.enable_flame_thrower(args) if target.powerup == TargetHandler::POWERUP_FLAMETHROWER
            PlayerHandler.enable_fire_blast(args) if target.powerup == TargetHandler::POWERUP_FIRE_BLAST

            deads += 1
            args.state.score += 1 unless target.powerup
          end
        end
      end

      args.state.targets.reject! { |t| t.dead }
      args.state.fireballs.reject! { |t| t.dead }

      deads.times do
        TargetHandler.spawn_target(args)
      end
    end

  end
end