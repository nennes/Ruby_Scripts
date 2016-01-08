begin
  File.open(ARGV[0]).each_line do |line|
    unless line.chomp.empty?
      str1, str2 = line.chomp.split(",")
      puts str1 =~ /.*#{str2}/ ? "1" : "0"
    end
  end
end