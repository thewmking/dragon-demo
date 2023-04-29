class TargetHandler
  TARGET_SPEED_RANGE = [1,2,3]

  POWERUP_FLAMETHROWER = 'flamethrower'

  class << self
    def init(args)
      if args.state.targets.nil?
        args.state.targets ||= []
        3.times do 
          spawn_target(args)
        end
      end
      animate_powerup_targets(args)
    end

    def spawn_target(args)
      return if args.state.targets.count > 5
      return spawn_flamethrower_target(args)# if rand < 0.05
      size = 64
      target = {
        x: size + args.grid.w,
        y: rand(args.grid.h - size * 2) + size,
        w: size,
        h: size,
        path: 'sprites/misc/target.png',
        speed: (TARGET_SPEED_RANGE.sample * 0.25 * 7.0),
        powerup: false,
      }

      args.state.targets << target
    end

    def spawn_flamethrower_target(args)
      size = 60
      target = {
        x: size + args.grid.w,
        y: rand(args.grid.h - 64 * 2) + 64,
        w: size,
        h: size,
        path: 'sprites/powerups/flamethrower-0.png',
        speed: (TARGET_SPEED_RANGE.sample * 0.5 * 10.0),
        powerup: POWERUP_FLAMETHROWER,
      }

      args.state.targets << target
    end

    def manage_targets(args)
      return unless args.state.play
      deads = 0

      args.state.targets.each do |target|
        target.x -= target.speed

        if target.x < (0-target.w)
          target.dead = true
          deads += 1
        end
      end

      args.state.targets.reject! { |t| t.dead }

      deads.times do
        TargetHandler.spawn_target(args)
      end
    end

    def animate_powerup_targets(args)
      return unless args.state.play
      args.state.targets.select{ |t| t.powerup }.each do |t|
        sprite_index = 0.frame_index(count: 2, hold_for: 4, repeat: true)
        t.path = "sprites/powerups/#{t.powerup}-#{sprite_index}.png"
      end
    end

  end
end