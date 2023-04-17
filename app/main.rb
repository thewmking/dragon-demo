require 'app/sprites/sprite.rb'
require 'app/sprites/frog_1.rb'

FPS = 60
HIGH_SCORE_FILE = "high-score.txt"

def tick args
  init_timer(args)
  if game_over?(args)
    game_over_tick(args)
    return
  end

  init(args)
  parse_directional_input(args)
  enforce_boundaries(args)
  parse_command_input(args)
  update_animations(args)
  render(args)
end

def init(args)
  args.state.score ||= 0
  args.state.player ||= {
    x: 120,
    y: 280,
    w: 100,
    h: 80,
    speed: diagonal?(args) ? 8 : 16,
    path: 'sprites/misc/dragon-0.png',
  }
  args.state.fireballs ||= []
  init_targets(args)
end

def init_timer(args)
  args.state.timer ||= 5 * FPS
  args.state.timer -= 1
end

def render(args)
  args.outputs.sprites << [args.state.player, args.state.fireballs, args.state.targets]
  args.outputs.labels << {
    x: 40,
    y: args.grid.h - 40,
    text: "Score: #{args.state.score}",
    size_enum: 4,
  }
  args.outputs.labels << {
    x: args.grid.w - 40,
    y: args.grid.h - 40,
    text: "Timer: #{(args.state.timer / FPS).round}",
    size_enum: 4,
    alignment_enum: 2,
  }
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

def parse_fireball_input(args)
  if fire_input?(args)
    args.state.fireballs << {
        x: args.state.player.x + args.state.player.w - 12,
        y: args.state.player.y + 10,
        w: 32,
        h: 32,
        path: 'sprites/misc/fireball.png'
      }
  end
end

def fire_input?(args)
  args.inputs.keyboard.key_down.z ||
  args.inputs.keyboard.key_down.j ||
  args.inputs.controller_one.key_down.a
end

def update_animations(args)
  manage_fireballs(args)
end

def manage_fireballs(args)
  deads = 0
  args.state.fireballs.each do |fireball|
    fireball.x += 15

    if fireball.x > args.grid.w
      fireball.dead = true
      next
    end

    args.state.targets.each do |target|
      if args.geometry.intersect_rect?(target, fireball)
        target.dead, fireball.dead = true, true
        deads += 1
        args.state.score += 1
      end
    end
  end

  args.state.targets.reject! { |t| t.dead }
  args.state.fireballs.reject! { |t| t.dead }

  deads.times do
    args.state.targets << spawn_target(args)
  end
end

def init_targets(args)
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

def game_over?(args)
  args.state.timer < 0
end

def game_over_tick(args)
  handle_high_score(args)
  handle_game_over_labels(args)

  if args.state.timer < -30 && fire_input?(args)
    $gtk.reset
  end
end

def handle_game_over_labels(args)
  labels = [
    {
      x: 40,
      y: args.grid.h - 40,
      text: "Game Over!",
      size_enum: 10,
    },
    {
      x: 40,
      y: args.grid.h - 90,
      text: "Score: #{args.state.score}",
      size_enum: 4,
    },
    {
      x: 40,
      y: args.grid.h - 132,
      text: "Fire to restart",
      size_enum: 2,
    },
    {
      x: 260,
      y: args.grid.h - 90,
      text: args.state.score > args.state.high_score ? 'New high score!' : "Score to beat: #{args.state.high_score}",
      size_enum: 3,
    },
  ]

  args.outputs.labels << labels
end

def handle_high_score(args)
  args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i

  if !args.state.saved_high_score && args.state.score > args.state.high_score
    args.gtk.write_file(HIGH_SCORE_FILE, args.state.score.to_s)
    args.state.saved_high_score = true
  end
end

$gtk.reset