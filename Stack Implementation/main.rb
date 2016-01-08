class Stack
  attr_accessor :list

  def initialize
    @list = []
  end

  def push item
    @list.push item
  end

  def pop
    @list.pop
  end

end

File.open(ARGV[0]).each_line do |line|
  
  stack = Stack.new
  output = []

  line = line.split(' ').map(&:to_i)

  line.each{ |item| stack.push item }

  loop do
    output << stack.pop
    break unless stack.pop
  end

  puts output.join(' ')
end