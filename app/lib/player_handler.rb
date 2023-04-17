require 'app/lib/input_handler.rb'

class PlayerHandler
  class << self

    def init_player(args)
      args.state.score ||= 0
      args.state.player ||= {
        x: 120,
        y: 280,
        w: 100,
        h: 80,
        speed: InputHandler.diagonal?(args) ? 8 : 16,
      }

      animate_player(args)
    end

    def animate_player(args)
      hold_for = InputHandler.player_is_moving?(args) ? 4 : 8
      sprite_index = 0.frame_index(count: 6, hold_for: hold_for, repeat: true)
      args.state.player.path = "sprites/misc/dragon-#{sprite_index}.png"
    end

    def enforce_boundaries(args)
      if args.state.player.x + args.state.player.w > args.grid.w
        args.state.player.x = args.grid.w - args.state.player.w
      end

      if args.state.player.y + args.state.player.h > args.grid.h
        args.state.player.y = args.grid.h - args.state.player.h
      end

      args.state.player.x = 0 if args.state.player.x < 0
      args.state.player.y = 0 if args.state.player.y < 0
    end
  end
end