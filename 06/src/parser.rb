require_relative 'instruction_type'
require_relative 'symbol_table'

class Parser

  def initialize(source_file)
    @source = source_file
    @symbols = SymbolTable.new
    @next_address = 16
    @instructions = []
  end

  def parse
    load_from_source
    scan_labels
    out = []
    @instructions.each do |instruction|
      out << parse_instruction(instruction) if instruction_type(instruction) != Instruction::TYPE_L
    end
    out
  end

  private

  def instruction_type(instruction)
    if instruction[0] == '@'
      Instruction::TYPE_A
    elsif instruction[0] == '('
      Instruction::TYPE_L
    else
      Instruction::TYPE_C
    end
  end

  def load_from_source
    File.foreach(@source) do |line|
      text = line.gsub(/\/\/.*$/, '').strip
      @instructions << text if text.length > 0
    end
  end

  def scan_labels
    current = 0
    @instructions.each do |instruction|
      if instruction_type(instruction) == Instruction::TYPE_L
        symbol = instruction[1..-2]
        @symbols.add(symbol, current) if !@symbols.contains?(symbol)
      else
        current += 1
      end
    end
  end

  def parse_instruction(instruction)
    type = instruction_type(instruction)
    if type == Instruction::TYPE_A
      {
        'type' => type,
        'value' => a_field(instruction)
      }
    else
      dest, comp, jump = c_fields(instruction)
      {
        'type' => type,
        'dest' => dest,
        'comp' => comp,
        'jump' => jump
      }
    end
  end

  def a_field(instruction)
    symbol = instruction[1..-1]
    return symbol.to_i if is_number?(symbol)

    if !@symbols.contains?(symbol)
      @symbols.add(symbol, @next_address)
      @next_address += 1
    end
    @symbols.address(symbol)
  end
  
  def c_fields(instruction)
    dest = ''
    comp = ''
    jump = ''

    comp_start_index = 0
    comp_end_index = -1
    equal_sign_index = instruction.index('=')
    deli_sign_index = instruction.index(';')

    if equal_sign_index
      dest = instruction[0..(equal_sign_index - 1)]
      comp_start_index = equal_sign_index + 1
    end

    if deli_sign_index
      jump = instruction[(deli_sign_index + 1)..-1]
      comp_end_index = deli_sign_index - 1
    end

    comp = instruction[comp_start_index..comp_end_index]
    return dest, comp, jump
  end

  def is_number?(s)
    /\A\d+\z/.match(s)
  end
end
