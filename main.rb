# rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    return to_enum(:my_each) unless block_given?

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
    return to_enum(:my_each_with_index) unless block_given?

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
    return to_enum(:my_select) unless block_given?

    if is_a?(Array) || is_a?(Range)
      selected_array = []
      my_each { |item| selected_array.push(item) if yield(item) }
      selected_array
    else
      selected_hash = {}
      my_each { |key, value| selected_hash[key] = value if yield(key, value) }
      selected_hash
    end
  end

  def my_all?(my_arg = nil)
    if block_given?
      my_each { |item| return false unless yield(item) == true }
    else
      my_each { |item| return false if item == false || item.nil? }
    end
    if my_arg.class == Regexp
      my_each { |item| return false unless item =~ my_arg }
    elsif my_arg.class == Class
      my_each { |item| return false unless item.is_a? my_arg }
    elsif my_arg.is_a? Numeric
      my_each { |item| return false unless item == my_arg }
    end
    true
  end

  def my_any?(my_arg = nil)
    if block_given?
      if is_a?(Array) || is_a?(Range)
        my_each { |item| return true if yield(item) == true }
      else
        my_each { |key, item| return true if yield(key, item) == true }
      end
    end
    if my_arg.is_a? Regexp
      my_each { |item| return true if item =~ my_arg }
    elsif my_arg.is_a? Class
      my_each { |item| return true if item.is_a? my_arg }
    elsif my_arg.is_a? String
      my_each { |item| return true if item == my_arg }
    else
      my_each { |item| return true if item == true }
    end
    false
  end

  def my_none?(my_arg = nil)
    is_none = true
    if block_given?
      my_each { |item| is_none = false if yield(item) == true }
    elsif my_arg.is_a? Regexp
      my_each { |item| is_none = false if item.to_s.match(my_arg) }
    elsif my_arg.is_a? Class
      my_each { |item| is_none = false if item.is_a? my_arg }
    else
      my_each { |item| is_none = false if item == true }
    end
    is_none
  end

  def my_count(params = nil)
    counter = 0
    if block_given?
      my_each { |item| counter += 1 if yield(item) }
    elsif params.nil?
      counter = to_a.length
    else
      my_each { |item| counter += 1 if params == item }
    end
    counter
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc.class == Proc

    if proc.class == Proc
      mapped_array = []
      my_each { |item| mapped_array.push(proc.call(item)) }
      mapped_array
    elsif is_a?(Array) || is_a?(Range)
      selected_array = []
      my_each { |item| selected_array.push(yield(item)) }
      selected_array
    else
      selected_hash = {}
      my_each { |key, value| selected_hash[key] = yield(key, value) }
      selected_hash
    end
  end

  def my_inject(initial = 0)
    return to_enum(:my_each) unless block_given?

    acc = initial # aptures initialization of the accumulator
    my_each { |item| acc = yield(acc, item) } if is_a?(Array) || is_a?(Range)
    acc
  end
end

# rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

p ['saheed', 'oladele', 'suretrust'].my_none?(/d/)
p ['saheed', 'oladele', 'suretrust'].none?(/d/)

p ['saheed', 'oladele', 'suretrust'].my_none?(5)
p ['saheed', 'oladele', 'suretrust'].none?(5)

puts 'Testing None'
p %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
p %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
p %w{ant bear cat}.my_none?(/d/)                        #=> true
p [1, 3.14, 42].my_none?(Float)                         #=> false
p [].my_none?                                           #=> true
p [nil].my_none?                                        #=> true
p [nil, false].my_none?                                 #=> true
p [nil, false, true].my_none?                           #=> false