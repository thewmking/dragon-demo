require 'app/sprites/sprite.rb'
require 'app/sprites/frog_1.rb'

def tick args
  init(args)
  parse_directional_input(args)
  enforce_boundaries(args)
  parse_command_input(args)
  update_animations(args)
  render(args)
end

def render(args)
  args.outputs.sprites << [args.state.player, args.state.fireballs]
end

def init(args)
  args.state.player ||= {
    x: 120,
    y: 280,
    w: 100,
    h: 80,
    speed: diagonal?(args) ? 6 : 12,
    path: 'sprites/misc/dragon-0.png',
  }
  args.state.fireballs ||= []
end

def diagonal?(args)
  (args.inputs.left_right) && (args.inputs.up_down)
end

def parse_directional_input(args)
  args.state.player.x += args.inputs.left_right * args.state.player.speed
  args.state.player.y += args.inputs.up_down * args.state.player.speed
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

def parse_command_input(args)
  handle_fireball_input(args)
end

def handle_fireball_input(args)
  if args.inputs.keyboard.key_down.z ||
     args.inputs.keyboard.key_down.j ||
     args.inputs.controller_one.key_down.a
    args.state.fireballs << {
      x: args.state.player.x + args.state.player.w - 12,
      y: args.state.player.y + 10,
      w: 32,
      h: 32,
      path: 'sprites/misc/fireball.png'
    }
  end
end

def update_animations(args)
  manage_fireballs(args)
end

def manage_fireballs(args)
  args.state.fireballs.each do |fireball|
    fireball.x += 15
  end
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
