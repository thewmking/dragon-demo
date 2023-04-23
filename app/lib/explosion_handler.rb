class ExplosionHandler
  DEATH_TIMER = 35

  class << self

    def init(args)
      args.state.explosions ||= []
    end

    def spawn_explosion(args, target)
      size = 64
      args.state.explosions << {
        x: target.x,
        y: target.y,
        w: size,
        h: size,
        path: 'sprites/misc/explosion-0.png',
        death_timer: DEATH_TIMER,
        init_tick: args.state.tick_count,
      }
    end

    def manage_explosions(args)
      return unless args.state.play
      args.state.explosions.each do |e|
        sprite_index = e.init_tick.frame_index(count: 7, hold_for: 5, repeat: false)
        e.path = "sprites/misc/explosion-#{sprite_index}.png"
        e.death_timer -= 1
        e.dead = true if e.death_timer == 0
      end

      args.state.explosions.reject! { |e| e.dead }
    end

  end
end