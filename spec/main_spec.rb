require './main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5] }
  let(:mixed_val) { [1, 2, 3, 4, 'a'] }
  let(:string_val) { %w[ant bear cat] }
  let(:float_val) { [1, 3.14, 42] }
  let(:nil_false_array) { [nil, false] }
  let(:hash) { { 'color' => '#fff', 'font_family' => 'Arial' } }

  describe '#my_each' do
    it 'returns each items of array/range if block is given' do
      result = []
      array.my_each { |item| result << item + 1 }
      expect(result).to eq([2, 3, 4, 5, 6])
    end

    it 'returns keys and values of hash if block is given' do
      result = []
      hash.my_each { |key, value| result << key + ' : ' + value }
      expect(result).to eq(['color : #fff', 'font_family : Arial'])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_each).to be_an(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'returns values and keys of array/range if block is given' do
      result = []
      array.my_each_with_index { |item, index| result << item + index }
      expect(result).to eq([1, 3, 5, 7, 9])
    end

    it 'returns values and keys of hash if block is given' do
      result = []
      hash.my_each_with_index { |value, key| result << value + ' : ' + key }
      expect(result).to eq(['color : #fff', 'font_family : Arial'])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end
  end

  describe '#my_select' do
    context 'if block is given returns true' do
      it 'returns an array containing all elements of array/range' do
        result = []
        array.my_select { |item| result << item if item.even? }
        expect(result).to eq([2, 4])
      end

      it 'returns a hash containing all elements/keys of hash' do
        result = hash.my_select { |val| val > 'a' }
        expect(result).to eq({ 'color' => '#fff', 'font_family' => 'Arial' })
      end
    end

    it 'returns empty array if block is given but returns false' do
      result = []
      array.my_select { |item| result << item if item > 10 }
      expect(result).to eq([])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_select).to be_an(Enumerator)
    end
  end

  describe '#my_all?' do
    context 'if block is given' do
      it 'returns true if block never returns false or nil' do
        result = string_val.my_all? { |item| item.length >= 3 }
        expect(result).to eq(true)
      end

      it 'returns false if block returns false or nil' do
        result = string_val.my_all? { |item| item.length >= 5 }
        expect(result).to eq(false)
      end
    end

    context 'if block is not given and param is not given' do
      it 'returns true if none of the items return false or nill' do
        expect(string_val.my_all?).to eq(true)
      end
    end

    context 'if block is not given but param is given' do
      it 'return true if param == class and all elements is a member of param given' do
        expect(string_val.my_all?(String)).to eq(true)
      end

      it 'return true if param == pattern and pattern === element for all elements' do
        expect(string_val.my_all?(/t/)).to eq(false)
      end
    end
  end

  describe '#my_any?' do
    context 'if block is given' do
      it 'returns true if block returns true for any of the elements of the array/range' do
        result = string_val.my_any? { |item| item.length >= 3 }
        expect(result).to eq(true)
      end

      it 'returns true if block returns true for any of the elements/keys of the hash' do
        result = hash.my_any? { |item, key| item.length >= 3 && key.length >= 3 }
        expect(result).to eq(true)
      end

      it 'returns false if block returns false for all elements' do
        expect(array.my_any? { |i| i == 6 }).to eq(false)
      end
    end

    context 'if block is not given and param is not given' do
      it 'return true if at least one of the collection members is not false or nil' do
        expect([nil, true, 99].my_any?).to eq(true)
      end

      it 'return false if collection has no member ' do
        expect([].my_any?).to eq(false)
      end
    end

    context 'if block is not given but param is given' do
      it 'return false if param == class and all elements is not a member of param given' do
        expect(string_val.my_all?(Integer)).to eq(false)
      end

      it 'return true if param == pattern and pattern === element for all elements' do
        expect(string_val.my_any?(/d/)).to eq(false)
      end
    end
  end

  describe '#my_none?' do
    context 'if block is given' do
      it 'returns true if the block never returns true for all elements' do
        expect(string_val.my_none? { |item| item.length >= 7 }).to eq(true)
      end

      it 'returns false if block returns true for any of the collection members' do
        expect(array.my_none? { |i| i == 3 }).to eq(false)
      end
    end

    context 'if block is not given and param is not given' do
      it 'return true only if none of the collection members is true' do
        expect(nil_false_array.my_none?).to eq(true)
      end

      it 'return true for empty collection' do
        expect([].my_none?).to eq(true)
      end
    end

    context 'if block is not given but param is given' do
      it 'return false if param == class and at least one collection instance is a member of the param' do
        expect(float_val.my_none?(Float)).to eq(false)
      end

      it 'return true if param == pattern and pattern === element for none of the collection members' do
        expect(string_val.my_none?(/d/)).to eq(true)
      end
    end
  end

  describe '#my_count' do
    context 'if block is given' do
      it 'counts the number of elements yielding a true value' do
        expect(string_val.my_count { |item| item.length == 3 }).to eq(2)
      end
    end

    context 'if block is not given and param is not given' do
      it 'counts the number of elements in the collection' do
        expect(string_val.my_count).to eq(3)
      end
    end

    context 'if block is not given but param is given' do
      it 'counts the number of items in enum that are equal to param' do
        expect(float_val.my_count(2)).to eq(0)
      end
    end
  end

  describe '#my_map' do
    it 'returns the enumerator data if block is not given' do
      expect(array.my_map).to be_an(Enumerator)
    end

    it 'returns a new array with the results of running block once for every element in enum' do
      result = []
      array.my_map { |item| result << item * item }
      expect(result).to match_array([1, 4, 9, 16, 25])
    end

    it 'returns keys and values of a newly created hash if block is given' do
      result = {}
      hash.my_map { |key, value| result[key] = value }
      expect(result).to eql({ 'color' => '#fff', 'font_family' => 'Arial' })
    end

    context 'if proc is not nil' do
      it 'returns a new array with the values already manipulated by the proc class' do
        result = []
        square = proc { |x| x * 2 }
        array.my_map { |val| result << square.call(val) }
        expect(result).to eql([2, 4, 6, 8, 10])
      end
    end
  end

  describe '#my_inject' do
    context 'if block is given' do
      it 'returns the value of an accumulator, if param.length == 0' do
        expect(array.my_inject { |sum, n| sum + n }).to eq(15)
      end
    end

    context 'if number of parameters is greater than zero' do
      context 'if param.length == 1 && param[0] == Integer' do
        it 'initializes the counter with the parameter and return the accumulator' do
          expect(array.my_inject(3) { |sum, n| sum + n }).to eq(18)
        end
      end

      context 'if param.length == 1 && param[0] == Symbol' do
        it 'uses the symbol in the block and returns the value of the accumulator' do
          expect(array.my_inject(:*)).to eq(120)
        end
      end

      context 'if param.length == 1 && param[0] is neither a symbol nor a string' do
        it 'return error message' do
          expect(array.my_inject('+')).to eq("undefined method '+' for 1:Integer")
        end
      end

      it 'initializes the counter with the parameter if param[0] == Integer && param[1] == Symbol' do
        expect(array.my_inject(3) { |sum, n| sum + n }).to eq(18)
      end
    end

    it 'returns error message if param.length > 2' do
      expect(array.my_inject(3, :+, :-)).to eql('Number of arguments cannot be more than 2')
    end
  end
end
