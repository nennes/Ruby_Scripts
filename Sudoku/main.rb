begin
  def get_region(row,col,n)
    region_dimensions = Math.sqrt(n)
    (((row / region_dimensions).to_i)* region_dimensions).to_i + (col / region_dimensions).to_i
  end

  File.open(ARGV[0]).each_line do |line|

    n,line = line.chomp.split(';')
    n,line = n.to_i, line.split(',').map(&:to_i)
    column_cnt = Array.new(n, 0)
    region_cnt = Array.new(n, 0)
    valid = line.length == n*n

    line.each_slice(n).to_a.each_with_index do |row, row_index|
      if valid
        row.each_with_index do|val, col_index|
          column_cnt[col_index] += val
          region_cnt[get_region(row_index, col_index, n)] += val
        end
        valid = row.uniq.count == n && row.min == 1 && row.max == n && row.inject(:+) == (1..n).inject(:+)
      end
    end

     puts valid && column_cnt.uniq.count == 1 && region_cnt.uniq.count == 1 && column_cnt[0] == (1..n).inject(:+) && region_cnt[0] == (1..n).inject(:+) ? 'True' : 'False'

  end
end