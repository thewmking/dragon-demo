class BackgroundHandler

  BACKGROUND_W = 3465

  class << self

    def init(args)
      args.state.backgrounds ||= [spawn_background]
    end

    def spawn_background(x: 0)
      {
        x: x,
        y: 0,
        w: BACKGROUND_W,
        h: 720,
        path: 'sprites/backgrounds/starry-mountains-720.png',
      }
    end

    def manage_backgrounds(args)
      return unless args.state.play

      puts "background count: #{args.state.backgrounds.length}"
      # TODO: figure out what is going on with this logic

      args.state.backgrounds.each do |background|
        if past_cutoff(background)
          background.dead = true
          next
        end
        
        if partially_on_screen(args, background)
          return if args.state.backgrounds.count > 2
          # TODO: do I need to factor in background speed here?
          args.state.backgrounds << spawn_background(x: background.x + BACKGROUND_W)
        end
        background.x -= 20
      end

      reject_backgrounds(args)
    end

    def reject_backgrounds(args)
      args.state.backgrounds.reject! { |b| b.dead }
    end

    def past_cutoff(background)
      background.x < -BACKGROUND_W
    end

    def partially_on_screen(args, background)
      background.x > -BACKGROUND_W &&
        background.x <= (args.grid.w - BACKGROUND_W)
    end

  end

end