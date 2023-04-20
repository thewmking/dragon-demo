require 'app/lib/music_handler.rb'
require 'app/lib/game_over_handler.rb'
require 'app/lib/cloud_handler.rb'
require 'app/lib/fireball_handler.rb'
require 'app/lib/input_handler.rb'
require 'app/lib/player_handler.rb'
require 'app/lib/explosion_handler.rb'

FPS = 60
HIGH_SCORE_FILE = "high-score.txt"

def tick args
  init_timer(args)

  if GameOverHandler.game_over?(args)
    GameOverHandler.game_over_tick(args)
    return
  end

  init(args)
  update_animations(args)
  render(args)
end

def init(args)
  MusicHandler.handle_music(args)
  PlayerHandler.init_player(args)

  FireballHandler.init(args)
  TargetHandler.init(args) 
  CloudHandler.init(args) 
  ExplosionHandler.init(args)

  InputHandler.parse_directional_input(args)
  PlayerHandler.enforce_boundaries(args)
  InputHandler.handle_command_input(args)
end

def init_timer(args)
  args.state.timer ||= 30 * FPS
  args.state.timer -= 1
end

def render(args)
  args.outputs.solids << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    r: 92,
    g: 120,
    b: 230,
  }

  args.outputs.sprites << [
    args.state.clouds,
    args.state.player,
    args.state.fireballs,
    args.state.targets,
    args.state.explosions,
  ]

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

def update_animations(args)
  FireballHandler.manage_fireballs(args)
  CloudHandler.manage_clouds(args)
  ExplosionHandler.manage_explosions(args)
end

$gtk.reset