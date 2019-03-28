module Memoize
  def memo(name)
    fn = instance_method(name)
    @@table = Hash.new{|k,v| k[v] = {}} if !defined? @@table

    define_method(name) do |*args|
      arg = [*args]
      return @@table[name][arg] if @@table[name].include?(arg)
      @@table[name][arg] = fn.bind(self).call(*args)
    end
  end
end