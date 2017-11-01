require 'minitest/autorun'
require '../src/code'
require '../src/instruction_type'

class Code
  public *self.private_instance_methods(false)
end

class CodeTest < Minitest::Test

  def setup
    @code = Code.new
    @instructions = [
      {
        'type' => Instruction::TYPE_A,
        'value' => 100
      },
      {
        'type' => Instruction::TYPE_C,
        'dest' => 'MD',
        'comp' => 'M+1',
        'jump' => 'JGT'
      }
    ]
  end

  def test_generate_type_a
    instruction = @instructions[0]
    code = @code.generate_type_a(instruction)
    assert_equal code, '0000000001100100'
  end

  def test_generate_type_c
    instruction = @instructions[1]
    code = @code.generate_type_c(instruction)
    assert_equal code, '1111110111011001'
  end

  def test_generate
    out = @code.generate(@instructions)
    assert_equal out.count, 2
  end
end
