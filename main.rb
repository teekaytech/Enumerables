module Enumerable
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
      self.my_each { |item| selected_array.push(item) if yield(item) }
      return selected_array
    else
      selected_hash = {}
      self.my_each { |key, value| selected_hash[key] = value if yield(key, value) }
      return selected_hash
    end
  end


  def my_all(my_arg)
    if my_arg.class == Regexp 
      self.my_all? { |item| item =~ my_arg }
    elsif my_arg.class == Class
      self.my_all? { |item| item.is_a? my_arg }
    else 
      self.my_all? { |item| item == my_arg }
    end
  end

  def my_all?(my_arg = nil)
    return my_all(my_arg) unless my_arg == nil

    if block_given?
      if is_a?(Array) || is_a?(Range)
        self.my_each { |item| return false if yield(item) == false || yield(item) == nil }
      else
        self.my_each { |key, item| return false if (yield(key, item) == true || yield(item) == nil) }
      end
    else
      self.my_each { |item| return false if item == false || item == nil }
    end
    true
  end

  def my_any?(my_arg = nil)
    if block_given? && my_arg == nil
      if is_a?(Array) || is_a?(Range)
        self.my_each { |item| return true if yield(item) == true }
      else
        self.my_each { |key, item| return true if yield(key, item) == true }
      end
      false
    end
    if my_arg == Regexp
      self.my_each { |item| return true if item.to_s.match(my_arg) }
    end
    if my_arg.is_a?Class
      self.my_each { |item| return true if item.is_a?my_arg }
    end
    if my_arg == nil
      self.my_each { |item| return true if item == true }
    end
    false
  end

  def my_none?(my_arg = nil)
    if block_given? && my_arg == nil
      if is_a?(Array) || is_a?(Range)
        self.my_each { |item| return false if yield(item) == true }
      else
        self.my_each { |key, item| return false if yield(key, item) == true }
      end
      true
    end
    if my_arg == Regexp
      self.my_each { |item| return false if item.to_s.match(my_arg) }
    end
    if my_arg.is_a?Class
      self.my_each { |item| return false if item.is_a?my_arg }
    end
    if my_arg == nil
      self.my_each { |item| return false if item == true }
    end
    true
  end

  def my_count(params = nil)
    counter = 0
    if block_given? 
      if self.is_a?(Array) || self.is_a?(Range)
        self.my_each do |item|
          counter += 1 if yield(item) == true
        end
      else #for Hashes
        self.my_each do |key, item| 
          counter += 1 if yield(key, item) == true
        end
      end
    else
      if self.is_a?(Array) || self.is_a?(Range)
        self.my_each do |item|
          counter += 1
        end
      else #for Hashes
        self.my_each do |key, item| 
          counter += 1
        end
      end
    end
    if params != nil
      counter = 0
      self.my_each { |item| counter += 1 if params == item }
    end
    counter
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc.class == Proc

    if proc.class == Proc
      mapped_array = []
      self.my_each { |item| mapped_array.push(proc.call(item)) }
      mapped_array
    else 
      if is_a?(Array) || is_a?(Range)
        selected_array = []
        self.my_each { |item| selected_array.push(yield(item)) }
        return selected_array
      else
        selected_hash = {}
        self.my_each { |key, value| selected_hash[key] = yield(key, value) }
        return selected_hash
      end
    end
  end

  def my_inject(initial = 0)
    return to_enum(:my_each) unless block_given?
    acc = initial #captures initialization of the accumulator
      if self.is_a?(Array) || self.is_a?(Range)
        self.my_each { |item| acc = yield(acc, item) }
      end
      acc
  end

end

p %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
p %w[ant bear cat].my_all?(/t/)                        #=> false
p [1, 2i, 3.14].my_all?(Numeric)                       #=> true
p [nil, true, 99].my_all?                              #=> false
p [].my_all?                                           #=> true