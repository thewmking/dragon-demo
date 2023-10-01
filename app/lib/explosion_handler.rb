class ExplosionHandler
  class << self

    def init(args)
      args.state.explosions ||= []
      args.state.sparkles ||= []
    end

    def spawn_explosion(args, target, color = nil)
      color = "#{color}-" unless color.nil?
      size = 64
      args.state.explosions << {
        x: target.x,
        y: target.y,
        w: size,
        h: size,
        color: color,
        path: "sprites/misc/explosion-#{color}0.png",
        death_timer: 35,
        init_tick: args.state.tick_count,
      }
    end

    def manage_explosions(args)
      return unless args.state.play
      args.state.explosions.each do |e|
        sprite_index = e.init_tick.frame_index(count: 7, hold_for: 5, repeat: false)
        e.path = "sprites/misc/explosion-#{e.color}#{sprite_index}.png"
        e.death_timer -= 1
        e.dead = true if e.death_timer == 0
      end

      args.state.explosions.reject! { |e| e.dead }
    end

    def spawn_sparkle(args, target)
      args.state.sparkles << {
        x: target.x,
        y: target.y,
        w: 142,
        h: 100,
        path: "sprites/sparkles/pu-sparkle-0.png",
        death_timer: 27,
        init_tick: args.state.tick_count,
      }
    end

    def manage_sparkles(args)
      return unless args.state.play
      args.state.sparkles.each do |e|
        sprite_index = e.init_tick.frame_index(count: 9, hold_for: 3, repeat: false)
        e.path = "sprites/sparkles/pu-sparkle-#{sprite_index}.png"
        e.death_timer -= 1
        e.dead = true if e.death_timer == 0
      end

      args.state.sparkles.reject! { |e| e.dead }
    end

  end
end