# rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Lint/RedundantCopDisableDirective, Style/GuardClause
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
    elsif my_arg.is_a? Numeric
      my_each { |item| return false if item == my_arg }
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

  def my_inject(*initial) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective
    return 'Number of arguments cannot be more than 2' if initial.length > 2

    acc = 0
    iterator = 0
    if initial.length.zero? && block_given?
      my_each do |item|
        iterator.zero? ? acc += item : acc = yield(acc, item)
        iterator += 1
      end
    elsif initial[0].is_a?(Integer) && initial[1].is_a?(Symbol)
      acc = initial[0]
      my_each { |item| acc = acc.method(initial[1]).call(item) }
    elsif initial[0].is_a?(Integer) && block_given?
      acc = initial[0]
      my_each { |item| acc = yield(acc, item) }
    elsif initial.length == 1 && !block_given?
      if initial[0].class != Symbol && initial[0].class != String
        return "#{initial[0]} is neither a string nor a symbol."
      elsif initial[0].is_a?(Symbol)
        my_each do |item|
          iterator.zero? ? acc += item : acc = acc.method(initial[0]).call(item)
          iterator += 1
        end
      elsif initial[0].is_a?(String)
        my_ops = %I[:+, :-, :*, :/, :==, :=~]
        if my_ops.my_any? { |op| op == initial[0].to_sym }
          my_each do |item|
            iterator.zero? ? acc += item : acc = acc.method(initial[0].to_sym).call(item) # rubocop:disable Metrics/BlockNesting
            iterator += 1
          end
        else
          return "undefined method '#{initial[0]}' for 1:Integer"
        end
      end
    end
    acc
  end
end
# rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Lint/RedundantCopDisableDirective, Style/GuardClause
