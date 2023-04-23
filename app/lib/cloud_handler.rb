
class CloudHandler
  CLOUD_SPEED_RANGE = [1,2,3]
  CLOUDS = [
    {
      path: 'sprites/clouds/cloud-01.png',
      w: 216,
      h: 129,
    },
    {
      path: 'sprites/clouds/cloud-02.png',
      w: 299,
      h: 155,
    },
    {
      path: 'sprites/clouds/cloud-03.png',
      w: 242,
      h: 127,
    },
    {
      path: 'sprites/clouds/cloud-04.png',
      w: 275,
      h: 103,
    },
  ]


  class << self

    def init(args)
      args.state.clouds ||= [spawn_cloud(args)]
    end

    def spawn_cloud(args)
      cloud = CLOUDS.sample
      {
        x: rand(args.grid.w) + args.grid.w / 2,
        y: rand(args.grid.h - cloud[:h] * 2) + cloud[:h],
        w: cloud[:w],
        h: cloud[:h],
        path: cloud[:path],
        speed: (CLOUD_SPEED_RANGE.sample * 0.25 * 5.0),
      }
    end

    def manage_clouds(args)
      return unless args.state.play
      deads = 0
      args.state.clouds.each do |cloud|
        cloud.x -= cloud.speed 

        if cloud.x < (0-cloud.w)
          cloud.dead = true
        end
      end

      args.state.clouds.reject! { |c| c.dead }

      deads.times do
        args.state.targets << spawn_cloud(args)
      end

      if args.state.clouds.count < 4
        args.state.clouds << spawn_cloud(args)
      end
    end

  end
end