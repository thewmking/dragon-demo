require 'app/lib/target_handler.rb'

class FireballHandler
  class << self

    def init(args)
      args.state.fireballs ||= []
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
            args.outputs.sounds << "sounds/target.wav"
            target.dead, fireball.dead = true, true
            deads += 1
            args.state.score += 1
          end
        end
      end

      args.state.targets.reject! { |t| t.dead }
      args.state.fireballs.reject! { |t| t.dead }

      deads.times do
        args.state.targets << TargetHandler.spawn_target(args)
      end
    end

  end
end