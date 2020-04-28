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
    return 'No block given' unless block_given?

    if is_a?(Array) || is_a?(Range)
      self.my_each do |item|
        return false if yield(item) == false
      end
      true
    else
      self.my_each do |key, item|
        return false if (yield(key, item) == false || nil)
      end
      true
    end
  end

  def my_any? 
    return 'No block given' unless block_given?

    if is_a?(Array) || is_a?(Range)
      self.my_each do |item|
        return true if yield(item) == true
      end
      false
    else
      self.my_each do |key, item|
        return true if yield(key, item) == true
      end
      false
    end
  end

  def my_none?
    if block_given?
      if self.is_a?(Array) || self.is_a?(Range)
        self.my_each do |item|
          return false if yield(item) == true 
        end
        true
      else # for Hashes
        self.my_each do |key, item|
          return false if yield(key, item) == true
        end
        true
      end
    else
      if self.is_a?(Array) || self.is_a?(Range)
        self.my_each do |item|
          return false if item == true 
        end
        true
      else #for Hashes
        self.my_each do |key, item|
          return false if item == true
        end
        true
      end
    end
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
      self.my_each do |item| 
        mapped_array.push(proc.call(item))
      end
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
        self.my_each do |item|
          acc = yield(acc, item)
        end
      end
      acc
  end

end

check = [1, 2, 3, 4, 5]
myproc = Proc.new{ |item| item * 3 }
p check.my_map(myproc) 
# testing #my_inject method with #multiply_els

def multiply_els(arr) 
  arr.my_inject(1) { |product, i| product * i }
end

# puts multiply_els([2, 4, 5])