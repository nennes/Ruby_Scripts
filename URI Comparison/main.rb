require 'uri'

begin

  def same? uri1, uri2
    (uri1.scheme.downcase == uri2.scheme.downcase) &&  # Scheme check
    (uri1.host.downcase   == uri2.host.downcase)   &&  # Host check
    (uri1.path            == uri2.path)            &&  # Path check, case sensitive
    (uri1.port            == uri2.port)                # Port check
  end

  p = URI::Parser.new(:UNRESERVED => URI::REGEXP::PATTERN::UNRESERVED + '\]\[') # Enhance the default parser to better handle the RFC3986 allowed characters

  File.open(ARGV[0], "r").each_line do |line|
    unless line.chomp!.empty?
      uri1, uri2 = line.split(';').collect{ |str| p.parse(URI.encode(URI.decode(str))) }   # decode the URI, then parse it to the URI datatype, then do a parallel assign
      puts same?(uri1, uri2) ? "True" : "False"
    end  
  end
end