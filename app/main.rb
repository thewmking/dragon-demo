require 'app/sprites/sprite.rb'
require 'app/sprites/frog_1.rb'

def tick args
  init(args)
  handle_input(args)
  enforce_boundaries(args)  
  render(args)
end

def render(args)
  args.outputs.sprites << [args.state.player_x, args.state.player_y, 100, 80, 'sprites/misc/dragon-0.png']
end

def init(args)
  args.state.player_x ||= 120
  args.state.player_y ||= 280
  args.state.speed = diagonal?(args) ? 6 : 12
  args.state.player_w = 100
  args.state.player_h = 80
end

def diagonal?(args)
  (args.inputs.left_right) && (args.inputs.up_down)
end

def handle_input(args)
  args.state.player_x += args.inputs.left_right * args.state.speed
  args.state.player_y += args.inputs.up_down * args.state.speed
end

def enforce_boundaries(args)
  if args.state.player_x + args.state.player_w > args.grid.w
    args.state.player_x = args.grid.w - args.state.player_w
  end

  if args.state.player_y + args.state.player_h > args.grid.h
    args.state.player_y = args.grid.h - args.state.player_h
  end

  args.state.player_x = 0 if args.state.player_x < 0
  args.state.player_y = 0 if args.state.player_y < 0
end

# class Sprite
#   attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b,
#                 :source_x, :source_y, :source_w, :source_h,
#                 :tile_x, :tile_y, :tile_w, :tile_h,
#                 :flip_horizontally, :flip_vertically,
#                 :angle_anchor_x, :angle_anchor_y, :blendmode_enum

#   def primitive_marker
#     :sprite
#   end
# end

# class Frog1 < Sprite
#   def initialize opts
#     @x = opts[:x]
#     @y = opts[:y]
#     @w = opts[:w]
#     @h = opts[:h]
#     @path = 'mygame/sprites/frogs/frog-1.png'
#   end
# end
