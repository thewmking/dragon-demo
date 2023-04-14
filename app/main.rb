require 'app/sprites/sprite.rb'
require 'app/sprites/frog_1.rb'

def tick args

  # init
  args.state.player_x ||= 120
  args.state.player_y ||= 280
  speed = diagonal?(args) ? 6 : 12
  player_w = 100
  player_h = 80

  # controls
  args.state.player_x += args.inputs.left_right * speed
  args.state.player_y += args.inputs.up_down * speed

  if args.state.player_x + player_w > args.grid.w
    args.state.player_x = args.grid.w - player_w
  end

  if args.state.player_y + player_h > args.grid.h
    args.state.player_y = args.grid.h - player_h
  end

  # enforce boundaries
  args.state.player_x = 0 if args.state.player_x < 0
  args.state.player_y = 0 if args.state.player_y < 0

  # rendering
  args.outputs.sprites << [args.state.player_x, args.state.player_y, 100, 80, 'sprites/misc/dragon-0.png']
end

def diagonal?(args)
  (args.inputs.left_right) && (args.inputs.up_down)
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
