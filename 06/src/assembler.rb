#!/usr/bin/env ruby

require_relative 'parser'
require_relative 'code'

class Assembler

  def initialize(source_file)
    @source = source_file
  end

  def assemble
    parser = Parser.new(@source)
    code = Code.new
    parsed_code = parser.parse
    translated_code = code.generate(parsed_code)
    File.write(@source.sub('.asm', '.hack'), translated_code.join("\n"))
  end
end


def main
  source = ARGV[0]
  if source && source.end_with?('.asm')
    assembler = Assembler.new(source)
    assembler.assemble
  else
    puts 'Usage: assembler <source_file>'
  end
end

main
