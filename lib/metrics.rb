require 'net/http'

module Metrics
  def filesystem_space
    `df -kP | grep "^/"`.split(/\n/).collect do |line|
      fields = line.split(/\s+/)
      device = fields[0].split(/\//).last
      used = fields[1].to_i - fields[3].to_i
      [device, (used.to_f / fields[1].to_f * 100).round]
    end
  end
  
  def load_1m
    IO.read('/proc/loadavg').split(/\s/)[0]
  end
  
  def mem_free
    from_proc_meminfo('MemFree').gsub(" kB$", '').to_i
  end
  
  def mem_total
    from_proc_meminfo('MemTotal').gsub(" kB$", '').to_i
  end
  
  def swap_free
    from_proc_meminfo('SwapFree').gsub(" kB$", '').to_i
  end
  
  def swap_total
    from_proc_meminfo('SwapTotal').gsub(" kB$", '').to_i
  end

  private
  
  def from_proc_meminfo(string)
    IO.read('/proc/meminfo').split(/\n/).detect {|line| line =~ /^#{Regexp.quote(string)}:\s+(.*)/}
    $1
  end
end
