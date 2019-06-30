require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase
  def self.startup
    @@items = [
        Item.new(name='Aged Brie', sell_in=2, quality=0),

        Item.new(name='Sulfuras, Hand of Ragnaros', sell_in=0, quality=80),

        Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=15, quality=20),
        Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=10, quality=20),
        Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=5, quality=20),
        Item.new(name='Backstage passes to a TAFKAL80ETC concert', sell_in=0, quality=20),

        Item.new(name='Conjured Mana Cake', sell_in=3, quality=6),
        Item.new(name='Conjured Mana Cake', sell_in=0, quality=6),

        Item.new(name='sell_in_and_quality_should_decrease', sell_in=10, quality=20),
        Item.new(name='quality_should_decrease_twice_after_date_passed', sell_in=-1, quality=20),
        Item.new(name='cannot_be_negative', sell_in=10, quality=-20),
        Item.new(name='cannot_be_more_than50', sell_in=10, quality=120),
    ]

    GildedRose.new(@@items).update_quality
  end

  def test_sulfuras
    item = @@items.find{|i| i.name =~ /^Sulfuras/}
    assert_equal item.sell_in, 0
    assert_equal item.quality, 80
  end

  def test_aged_brie
    item = @@items.find{|i| i.name == 'Aged Brie'}
    assert_equal item.sell_in, 1
    assert_equal item.quality, 1
  end

  def test_backstage
    assert_not_nil @@items.find{|i| i.name =~ /^Backstage passes/ && i.sell_in == 14 && i.quality == 21}
    assert_not_nil @@items.find{|i| i.name =~ /^Backstage passes/ && i.sell_in == 9 && i.quality == 22}
    assert_not_nil @@items.find{|i| i.name =~ /^Backstage passes/ && i.sell_in == 4 && i.quality == 23}
    assert_not_nil @@items.find{|i| i.name =~ /^Backstage passes/ && i.sell_in == -1 && i.quality == 0}
  end

  def test_conjured
    assert_not_nil @@items.find{|i| i.name == 'Conjured Mana Cake' && i.sell_in == 2 && i.quality == 4}
    assert_not_nil @@items.find{|i| i.name == 'Conjured Mana Cake' && i.sell_in == -1 && i.quality == 2}
  end

  def test_sell_in_and_quality_should_decrease
    item = @@items.find{|i| i.name == 'sell_in_and_quality_should_decrease'}
    assert_equal item.sell_in, 9
    assert_equal item.quality, 19
  end

  def test_quality_should_decrease_twice_after_date_passed
    item = @@items.find{|i| i.name == 'quality_should_decrease_twice_after_date_passed'}
    assert_equal item.quality, 18
  end

  def test_quality_cannot_be_negative
    item = @@items.find{|i| i.name == 'cannot_be_negative'}
    assert_equal item.quality, 0
  end

  def test_quality_cannot_be_more_than50
    item = @@items.find{|i| i.name == 'cannot_be_more_than50'}
    assert_equal item.quality, 50
  end
end