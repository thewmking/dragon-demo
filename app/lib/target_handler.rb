class TargetHandler
  TARGET_SPEED_RANGE = [1,2,3]

  POWERUP_FLAMETHROWER = 'flamethrower'
  POWERUP_FIRE_BLAST = 'fire_blast'

  FLAMETHROWER_TIMER = :flame_thrower_timer
  FIRE_BLAST_TIMER = :fire_blast_timer

  POWERUPS = [
    POWERUP_FLAMETHROWER,
    POWERUP_FIRE_BLAST,
  ]

  POWERUP_TIMER_MAP = {
    POWERUP_FLAMETHROWER => FLAMETHROWER_TIMER,
    POWERUP_FIRE_BLAST => FIRE_BLAST_TIMER,
  }

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
      return spawn_powerup_target(args) if rand < 0.05

      args.state.targets << gen_target_normal(args)
    end

    def spawn_powerup_target(args)
      args.state.targets << gen_target_powerup(args)
    end

    def gen_target_normal(args, x: nil, y: nil)
      size = 64
      x ||= size + args.grid.w
      y ||= rand(args.grid.h - size * 2) + size
      {
        x: x,
        y: y,
        w: size,
        h: size,
        path: 'sprites/misc/target.png',
        speed: (TARGET_SPEED_RANGE.sample * 0.25 * 7.0),
        powerup: false,
      }
    end

    def gen_target_powerup(args, powerup: POWERUPS.sample, x: nil, y: nil)
      size = 60
      x ||= size + args.grid.w
      y ||= rand(args.grid.h - size * 2) + size
      {
        x: x,
        y: y,
        w: size,
        h: size,
        path: "sprites/powerups/#{powerup}-0.png",
        speed: (TARGET_SPEED_RANGE.sample * 0.5 * 10.0),
        powerup: powerup,
      }
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
      powerup_targets(args).each do |t|
        sprite_index = 0.frame_index(count: 2, hold_for: 8, repeat: true)
        t.path = "sprites/powerups/#{t.powerup}-#{sprite_index}.png"
      end
    end

    def powerup_targets(args)
      args.state.targets.select{ |t| t.powerup }
    end

  end
end