class CSSCompressor

  #Constructor
  def initialize(filename)
    @filename = filename
  end

  #Strips files of single line comments and empty lines
  def compress_to(destination_filename)
    outfile = File.open(destination_filename, 'w')
    infile = File.open(@filename, 'r')
    line = infile.gets.chomp
    while line
      line.strip!
      if line.length > 0 && !(line[0, 1] == "/*") && !(line[line.length - 2, line.length - 1] == "*/")
        outfile.write(line)
        if (line = infile.gets)
          outfile.write("\n")
        end
      else
        line = infile.gets.chomp
      end

    end
    outfile.close
    infile.close
  end
end

csscompress = CSSCompressor.new("css_comp_in")
csscompress.compress_to("css_comp_out")