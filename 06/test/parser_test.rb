require 'minitest/autorun'
require '../src/parser'
require '../src/instruction_type'

class Parser
  public *self.private_instance_methods(false)
end

class ParserTest < Minitest::Test

  def setup
    @parser = Parser.new('./data/test.asm')
  end

  def test_instruction_type_a_1
    text = '@100'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_A
    assert_equal @parser.a_field(text), 100
  end

  def test_instruction_type_a_2
    text = '@sum'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_A
    assert_equal @parser.a_field(text), 16
  end

  def test_instruction_type_l
    text = '(LOOP)'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_L
  end

  def test_instruction_type_c_1
    text = 'MD=M+1;JGE'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_C
    dest, comp, jump = @parser.c_fields(text)
    assert_equal dest, 'MD'
    assert_equal comp, 'M+1'
    assert_equal jump, 'JGE'
  end

  def test_instruction_type_c_2
    text = 'AMD=1'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_C
    dest, comp, jump = @parser.c_fields(text)
    assert_equal dest, 'AMD'
    assert_equal comp, '1'
    assert_equal jump, ''
  end

  def test_instruction_type_c_3
    text = '0;JMP'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_C
    dest, comp, jump = @parser.c_fields(text)
    assert_equal dest, ''
    assert_equal comp, '0'
    assert_equal jump, 'JMP'
  end

  def test_instruction_type_c_4
    text = 'D'
    assert_equal @parser.instruction_type(text), Instruction::TYPE_C
    dest, comp, jump = @parser.c_fields(text)
    assert_equal dest, ''
    assert_equal comp, 'D'
    assert_equal jump, ''
  end

  def test_parse_instruction_type_a
    text = '@100'
    parsed_text = @parser.parse_instruction(text)
    assert_equal parsed_text['type'], Instruction::TYPE_A
    assert_equal parsed_text['value'], 100
  end

  def test_parse_instruction_type_c
    text = 'MD=M+1;JMP'
    parsed_text = @parser.parse_instruction(text)
    assert_equal parsed_text['type'], Instruction::TYPE_C
    assert_equal parsed_text['dest'], 'MD'
    assert_equal parsed_text['comp'], 'M+1'
    assert_equal parsed_text['jump'], 'JMP'
  end

  def test_parse
    out = @parser.parse
    assert_equal out.count, 2
  end
end
