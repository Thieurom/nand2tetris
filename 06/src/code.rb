require_relative 'instruction_type'

class Code

  @@DEST_CODES= ['', 'M', 'D', 'MD', 'A', 'AM', 'AD', 'AMD']

  @@COMP_CODES = {
    '0'   => '0101010',
    '1'   => '0111111',
    '-1'  => '0111010',
    'D'   => '0001100',
    'A'   => '0110000',
    '!D'  => '0001101',
    '!A'  => '0110001',
    '-D'  => '0001111',
    '-A'  => '0110011',
    'D+1' => '0011111',
    'A+1' => '0110111',
    'D-1' => '0001110',
    'A-1' => '0110010',
    'D+A' => '0000010',
    'D-A' => '0010011',
    'A-D' => '0000111',
    'D&A' => '0000000',
    'D|A' => '0010101',
    'M'   => '1110000',
    '!M'  => '1110001',
    '-M'  => '1110011',
    'M+1' => '1110111',
    'M-1' => '1110010',
    'D+M' => '1000010',
    'D-M' => '1010011',
    'M-D' => '1000111',
    'D&M' => '1000000',
    'D|M' => '1010101'
  }

  @@JUMP_CODES = ['', 'JGT', 'JEQ', 'JGE', 'JLT', 'JNE', 'JLE', 'JMP']

  def generate(instructions)
    out = []
    instructions.each do |instruction|
      if instruction['type'] == Instruction::TYPE_A
        code = generate_type_a(instruction)
      elsif instruction['type'] == Instruction::TYPE_C
        code = generate_type_c(instruction)
      end
      out << code
    end
    out
  end

  private
  
  def generate_type_a(instruction)
    address = instruction['value']
    code = "%016b" % address
  end

  def generate_type_c(instruction)
    dest = dest_code(instruction['dest'])
    comp = comp_code(instruction['comp'])
    jump = jump_code(instruction['jump'])
    code = '111' + comp + dest + jump
  end

  def dest_code(mnemonic)
    "%03b" % @@DEST_CODES.index(mnemonic)
  end

  def comp_code(mnemonic)
    @@COMP_CODES[mnemonic]
  end

  def jump_code(mnemonic)
    "%03b" % @@JUMP_CODES.index(mnemonic)
  end
end
