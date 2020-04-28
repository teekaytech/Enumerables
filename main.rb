module Enumerable
  def my_each
    index = 0
    while index < size
      if is_a?(Array)
        yield(self[index])
      elsif is_a?(Hash)
        yield(keys[index], self[keys[index]])
      elsif is_a?(Range)
        yield(to_a[index])
      else
        yield
      end
      index += 1
    end
  end

  def my_each_with_index
    index = 0
    while index < size
      if is_a?(Array)
        yield(self[index], index)
      elsif is_a?(Hash)
        yield(keys[index], self[keys[index]])
      elsif is_a?(Range)
        yield(to_a[index], index)
      else
        yield
      end
      index += 1
    end
  end

  def my_select
    if is_a?(Array) || is_a?(Range)
      selected_array = []
      self.my_each { |item| selected_array.push(item) if yield(item) }
      return selected_array
    else
      selected_hash = {}
      self.my_each { |key, value| selected_hash[key] = value if yield(key, value) }
      return selected_hash
    end
  end

  def my_all?
    if is_a?(Array) || is_a?(Range)
      self.my_each do |item|
        return false if yield(item) == false
      end
      true
    else
      self.my_each do |key, item|
        return false if yield(key, item) == false
      end
      true
    end
  end

  
  my_arr = [12, 10, 2, 5, 20, 17]
  my_ha = { mine: 1, yours: 2 }
  my_ra = 1..5

  # p my_ha.my_all?{ |key, value| value.is_a?Integer }
  # p my_ra.my_all? { |item| item.is_a?Integer }

  # puts 'Testing my_each'
  # my_ra.my_each { |item| puts "#{item} is here" }
  # my_arr.my_each { |item| puts item }
  # my_ha.my_each { |key, item| puts "#{key} => #{item}" }

  # puts 'Testing my_each_with_index'
  # my_ra.my_each_with_index { |item, i| puts "#{item} is here with #{i + 1}" }
  # my_arr.my_each_with_index { |item, i| puts "#{item} with #{i}" }
  # my_ha.my_each_with_index { |key, item| puts "#{key} => #{item}" }
end
