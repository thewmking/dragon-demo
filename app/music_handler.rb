class MusicHandler

  def self.handle_music(args)
    if args.state.tick_count == 1
      args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
    end

    if args.state.timer == 0
      args.audio[:music].paused = true
      args.outputs.sounds << "sounds/game-over.wav"
    end
  end
end