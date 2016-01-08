begin
    @ip_addresses = Hash.new(0)
    @input = Array.new{Array.new}

    SECTION_2_MASK  = 0b00000000111111110000000000000000
    SECTION_3_MASK  = 0b00000000000000001111111100000000
    SECTION_4_MASK  = 0b00000000000000000000000011111111

  def load
    File.open(ARGV[0]).each_line do |line|
      @input << line.chomp
    end
  end

  def is_valid? ip
    ip.between?(0x01000000,0xFFFFFFFE)
  end

  def format ip
    "#{ip >> 24}.#{(ip&SECTION_2_MASK) >> 16}.#{(ip&SECTION_3_MASK) >> 8}.#{ip&SECTION_4_MASK}"
  end

  def match_candidates line
    # Identify all the IPs, save in standard format
    candidates = Array.new

    # dotted decimal
    candidates << line.scan(/0*\d{,3}\.0*\d{,3}\.0*\d{,3}\.0*\d{,3}/)
                      .map{|ip| ip.split('.').inject(0){ |t,v| v.to_i + t*256 }}

    # dotted hex
    candidates << line.scan(/0x0*\h{,2}\.0x0*\h{,2}\.0x0*\h{,2}\.0x0*\h{,2}/)
                      .map{|ip| ip.split('.').inject(0){ |t,v| v.to_i(16) + t*256 }}

    # dotted octal
    candidates << line.scan(/00*[0-7]{,3}\.00*[0-7]{,3}\.00*[0-7]{,3}\.00*[0-7]{,3}/)
                      .map{|ip| ip.split('.').inject(0){ |t,v| v.to_i(8) + t*256 }}

    # dotted binary
    candidates << line.scan(/0*[01]{,8}\.0*[01]{,8}\.0*[01]{,8}\.0*[01]{,8}/)
                      .map{|ip| ip.split('.').inject(0){ |t,v| v.to_i(2) + t*256 }}

    # binary
    candidates << line.scan(/0*[01]{,32}/)
                      .map{|v| v.to_i(2)}

    # octal
    candidates << line.scan(/0[0-7]{,12}/)
                      .map{|v| v.to_i(8)}

    # hex
    candidates << line.scan(/0x\h{8}/)
                      .map{|v| v.to_i(16)}

    # decimal
    candidates << line.scan(/\d?<!0*\d{8,10}?!\d/)
                      .map(&:to_i)

    candidates.each { |ips| ips.each{ |ip| @ip_addresses[ip] += 1 if is_valid? ip }}
  end

  def find_ips
    @input.each { |line| match_candidates line }
  end

  load
  find_ips
  max_ip_count = @ip_addresses.values.max
  print @ip_addresses.select { |k, v| v == max_ip_count }.keys.sort.map{ |ip| format ip}.join(' ')

end