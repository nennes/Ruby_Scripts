begin
  File.open(ARGV[0]).each_line do |line|
    state = []
    line = line.chomp.split("")
    ok = line.length > 0 ? true : false
    while ok && line.length > 0
      case line.pop
        when '('
          ok = false unless state.pop == 'p'
        when ')'
          state.push 'p'
        when '['
          ok = false unless state.pop == 's'
        when ']'
          state.push 's'
        when '{'
          ok = false unless state.pop == 'c'
        when '}'
          state.push 'c'
      end
    end
    puts ok ? "True" : "False"
  end
end