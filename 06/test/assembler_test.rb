require 'minitest/autorun'
require '../src/assembler'

class AssemblerTest < Minitest::Test

  def setup
    source_file = './data/test.asm'
    @assembler = Assembler.new(source_file)
  end

  def test_assemble_source_file
    refute File.exist? './data/test.hack'
    @assembler.assemble
    assert File.exist? './data/test.hack'
  end

  def teardown
    File.delete './data/test.hack'
  end
end
