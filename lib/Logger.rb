module Logger

  public

  def self.is_new?(log, string)
    return !File.open(log, 'a+').each_line.any?{|line| line.include?(string)}
  end

  def self.add(log, string)
    File.open(log, 'a+'){|file|
      file.puts string
    }
  end
end
