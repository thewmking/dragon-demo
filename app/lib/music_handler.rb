class MusicHandler

  class << self
    def start_music(args)
      args.audio[:music] ||= { input: "sounds/flight.ogg", looping: true }
    end

    def stop_music(args)
      args.audio[:music].paused = true
    end

    def game_over_sound(args)
      args.outputs.sounds << "sounds/game-over.wav"
    end

  end
end