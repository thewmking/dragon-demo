require 'app/lib/scene_handlers/game_play_handler.rb'

class MusicHandler

  class << self
    def start_music(args)
      return if GamePlayHandler.muted?
      args.audio[:music] ||= { input: "sounds/flight.ogg", looping: true }
    end

    def stop_music(args)
      return if GamePlayHandler.muted?
      args.audio[:music].paused = true
    end

    def game_over_sound(args)
      return if GamePlayHandler.muted?
      args.outputs.sounds << "sounds/game-over.wav"
    end

  end
end