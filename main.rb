module Enumerable
  def my_each
    return 'No block given' unless block_given?

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
    return 'No block given' unless block_given?

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

  my_arr = [12, 10, 2, 5, 20, 17]
  my_ha = { mine: 1, yours: 2 }
  my_ra = 1..5

  puts 'Testing my_each'
  my_ra.my_each { |item| puts "#{item} is here" }
  my_arr.my_each { |item| puts item }
  my_ha.my_each { |key, item| puts "#{key} => #{item}" }

  puts 'Testing my_each_with_index'
  my_ra.my_each_with_index { |item, i| puts "#{item} is here with #{i + 1}" }
  my_arr.my_each_with_index { |item, i| puts "#{item} with #{i}" }
  my_ha.my_each_with_index { |key, item| puts "#{key} => #{item}" }
end
