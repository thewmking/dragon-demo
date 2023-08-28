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

      args.state.backgrounds.each do |background|
        background.x -= 0.5

        if past_cutoff(background)
          background.dead = true
        end
        
        if partially_on_screen(args, background)
          next if args.state.backgrounds.count > 2
          args.state.backgrounds << spawn_background(x: background.x + BACKGROUND_W)
        end        
      end

      reject_backgrounds(args)
    end

    def reject_backgrounds(args)
      args.state.backgrounds.reject! { |b| b.dead }
    end

    def past_cutoff(background)
      background.x < (0-BACKGROUND_W)
    end

    def partially_on_screen(args, background)
      background.x > (0-BACKGROUND_W) &&
        background.x <= (args.grid.w - BACKGROUND_W)
    end

  end

end