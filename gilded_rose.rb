class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      sell_in_decrease!(item)
      quality_step = item.sell_in < 0 ? 2 : 1
      case item.name
      when /^Sulfuras/
        # print "Sulfuras, being a legendary item, never has to be sold or decreases in Quality"
      when 'Aged Brie'
        item.quality += 1 # = [item.quality + 1, 50].min
      when /^Backstage passes/
        set_backstage_quality!(item)
      when /^Conjured/
        item.quality -= quality_step*2
      else
        item.quality -= quality_step
      end
      check_quality!(item)
    end
  end

  private

  def sell_in_decrease!(item)
    item.sell_in -= 1 unless item.name =~ /^Sulfuras/
  end

  def set_backstage_quality!(item)
    if item.sell_in < 0
      item.quality = 0
    else
      quality_step = 1
      quality_step = 2 if item.sell_in < 10 #.in?(6..10)
      quality_step = 3 if item.sell_in < 5 #.in?(0..5)
      item.quality = [item.quality + quality_step, 50].min
    end
  end

  def check_quality!(item)
    if item.name =~ /^Sulfuras/
      # item.quality = 80
    elsif item.quality > 50
      item.quality = 50
    elsif item.quality < 0
      item.quality = 0
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
