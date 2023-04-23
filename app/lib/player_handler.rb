require 'app/lib/input_handler.rb'

class PlayerHandler

  DRAGON_PINK   = 'pink'
  DRAGON_GREEN  = 'green'
  DRAGON_BLUE   = 'blue'
  DRAGON_RED    = 'red'
  DRAGON_YELLOW = 'yellow'
  DRAGON_BLACK  = 'black'

  DRAGON_VARIANTS = [
    DRAGON_PINK,
    DRAGON_GREEN,
    DRAGON_BLUE,
    DRAGON_RED,
    DRAGON_YELLOW,
    DRAGON_BLACK,
  ]
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
      args.state.player.path = "sprites/dragons/dragon-#{args.state.dragon.variant}-#{sprite_index}.png"
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