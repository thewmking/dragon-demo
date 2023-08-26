class BackgroundHandler

  class << self

    def init(args)
      args.state.background ||= init_background
    end

    def init_background
      {
        x: 0,
        y: 0,
        w: 3465,
        h: 720,
        path: 'sprites/backgrounds/starry-mountains-720.png'
      }
    end

    def animate_background(args)
      args.state.background.x -= 2 if args.state.play
    end

  end

end