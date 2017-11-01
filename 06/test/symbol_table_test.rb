require 'minitest/autorun'
require '../src/symbol_table'

class SymbolTableTest < Minitest::Test

  def setup
    @table = SymbolTable.new
  end

  def test_new_instance
    assert_equal @table.table.count, 23
  end

  def test_add_new_entry
    @table.add('sum', 16)
    assert_equal @table.table.count, 24
  end

  def test_contains_entry
    assert @table.contains?('SCREEN')
  end

  def test_address
    assert_equal @table.address('KBD'), 0x6000
  end
end
