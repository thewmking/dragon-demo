class Frog1 < Sprite
  def initialize opts
    @x = opts[:x]
    @y = opts[:y]
    @w = opts[:w]
    @h = opts[:h]
    @flip_horizontally = opts[:flip_h]
    @path = 'mygame/sprites/frogs/frog-1.png'
  end
end