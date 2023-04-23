require 'app/lib/input_handler.rb'

class PlayerHandler

  DRAGON_PINK   = 'pink'
  DRAGON_GREEN  = 'green'
  DRAGON_BLUE   = 'blue'
  DRAGON_RED    = 'red'
  DRAGON_YELLOW = 'yellow'
  DRAGON_BLACK  = 'black'
  DRAGON_WHITE  = 'white'

  DRAGON_VARIANTS = [
    DRAGON_PINK,
    DRAGON_GREEN,
    DRAGON_BLUE,
    DRAGON_RED,
    DRAGON_YELLOW,
    DRAGON_BLACK,
    DRAGON_WHITE,
  ]

  SHEET_VARIANTS = [
    # DRAGON_BLACK,
    # DRAGON_WHITE,
  ]

  class << self

    def init_player(args)
      args.state.score ||= 0
      args.state.player ||= {
        x: 120,
        y: 280,
        w: 100,
        h: 80,
        source_x: 0,
        source_y: 0,
        source_w: 100,
        source_h: 80,
        speed: InputHandler.diagonal?(args) ? 8 : 16,
      }

      if SHEET_VARIANTS.include? args.state.dragon.variant
        animate_player_sheet(args) 
      else
        animate_player(args)
      end
    end

    def animate_player(args)
      return unless args.state.play
      hold_for = InputHandler.player_is_moving?(args) ? 4 : 8
      sprite_index = 0.frame_index(count: 6, hold_for: hold_for, repeat: true)
      args.state.player.path = "sprites/dragons/dragon-#{args.state.dragon.variant}-#{sprite_index}.png"
    end

    # unused
    def animate_player_sheet(args)
      return unless args.state.play
      args.state.player.path ||= "sprites/dragons/dragon-#{args.state.dragon.variant}-sheet.png"
      hold_for = InputHandler.player_is_moving?(args) ? 4 : 8
      args.state.player.source_x = args.state.player.source_w * 0.frame_index(count: 6, hold_for: hold_for, repeat: true)
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