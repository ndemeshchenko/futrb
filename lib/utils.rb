module Util

  def self.is_api_message(data)
    res = (data && data.debug && data.string && data.code && data.reason)
    return true if res
    return false
  end

  def self.format(pattern, values)
    value.each_with_index do |v,i|
      pattern = pattern.gsub("{#{i}}", values[i])
    end
    return pattern
  end

  def self.is_price_valid?(coins)
    return false if coins < 150
    return (coins % 50) == 0 if coins < 1000
    return (coins % 100) == 0 if coins < 10000
    return (coins % 250) == 0 if coins < 50000
    return (coins % 500) == 0 if coins < 100000
    return (coins % 1000) == 0
  end

  def self.calculate_valid_price(coins)
      return 150 if coins < 150
      return coins - (coins % 50) if coins < 1000
      return  coins - (coins % 100) if coins < 10000
      return coins - (coins % 250) if coins < 50000
      return coins - (coins % 500) if coins < 100000
      return coins - (coins % 1000)
  end

  def self.calculate_next_lower_price(coins)
    coins = self.calculate_valid_price(coins)
    return 150 if coins <= 150
    return coins - 50 if coins <= 1000
    return  coins - 100 if coins <= 10000
    return coins - 250 if coins <= 50000
    return coins - 500 if coins <= 100000
    return coins - 1000
  end

  def self.calculate_next_higher_price(coins)
      coins = self.calculate_valid_price(coins);
      return coins + 1000 if coins >= 100000
      return coins + 500 if coins >= 50000
      return coins + 250 if coins >= 10000
      return coins + 100 if coins >= 1000
      return coins + 50
  end

  def self.get_base_id(id)
    while id > 16777216 do
       id -= 16777216
    end
    return id
  end

end
