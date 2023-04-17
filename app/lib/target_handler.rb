
class TargetHandler
  class << self

    def init(args)
      args.state.targets ||= [
        spawn_target(args),
        spawn_target(args),
        spawn_target(args),
      ]
    end

    def spawn_target(args)
      size = 64
      {
        x: rand((args.grid.w - size) * 0.4) + (args.grid.w - size)* 0.6,
        y: rand(args.grid.h - size * 2) + size,
        w: size,
        h: size,
        path: 'sprites/misc/target.png',
      }
    end

  end
end