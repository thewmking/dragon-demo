class InputHandler
  class << self

    def parse_directional_input(args)
      args.state.player.x += args.inputs.left_right * args.state.player.speed
      args.state.player.y += args.inputs.up_down * args.state.player.speed
    end

    def handle_command_input(args)
      if mute_input?(args)
        args.audio[:music].paused = !args.audio[:music].paused
      end

      if fire_input?(args)
        args.outputs.sounds << "sounds/fireball.wav"
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

    def mute_input?(args)
      args.inputs.keyboard.key_down.m
    end

    def diagonal?(args)
      (args.inputs.left_right) && (args.inputs.up_down)
    end

  end
end