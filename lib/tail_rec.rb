require 'method_source'

module TailRec
  def rec(name)
    fn = instance_method(name)
    src = fn.source.gsub(/^\s*rec\s*/, '')

    RubyVM::InstructionSequence.compile_option = \
      {tailcall_optimization: true, trace_instruction: false}

    RubyVM::InstructionSequence.new(<<-EOS).eval
      class #{to_s}
        #{src}
      end
    EOS
  end
end