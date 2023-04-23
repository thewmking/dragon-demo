require 'app/lib/fireball_handler.rb'

class InputHandler
  class << self

    def player_is_moving?(args)
      args.inputs.left_right != 0 || args.inputs.up_down != 0
    end

    def parse_directional_input(args)
      args.state.player.x += args.inputs.left_right * args.state.player.speed
      args.state.player.y += args.inputs.up_down * args.state.player.speed
    end

    def handle_command_input(args)
      if mute_input?(args)
        args.audio[:music].paused = !args.audio[:music].paused
      end

      FireballHandler.spawn_fireball(args) if fire_input?(args)
    end

    def fire_input?(args)
      return unless args.state.play
      # TODO: key_held.z for fire blast mode
      # args.inputs.keyboard.key_held.z ||
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

    def key_up_left?(args)
      args.inputs.keyboard.key_up.left ||
      args.inputs.controller_one.key_up.left
    end

    def key_up_right?(args)
      args.inputs.keyboard.key_up.right ||
      args.inputs.controller_one.key_up.right
    end

    def input_pause?(args)
      args.inputs.keyboard.key_down.p
    end

  end
end