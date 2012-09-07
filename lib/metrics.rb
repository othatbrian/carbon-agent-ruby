require 'net/http'

module Metrics
  def apache_active_workers
    response = Net::HTTP.get('localhost', '/server-status?auto')
    response.split(/\n/).detect {|line| line =~ /^BusyWorkers: (\d+)/}
    $1.to_i
  end

  def apache_idle_workers
    response = Net::HTTP.get('localhost', '/server-status?auto')
    response.split(/\n/).detect {|line| line =~ /^IdleWorkers: (\d+)/}
    $1.to_i
  end
  
  def load_1m
    IO.read('/proc/loadavg').split(/\s/)[0]
  end
  
  def mem_free
    IO.read('/proc/meminfo').split(/\n/)[1].split[1].to_i
  end
  
  def mem_total
    IO.read('/proc/meminfo').split(/\n/)[0].split[1].to_i
  end
  
  def swap_free
    IO.read('/proc/meminfo').split(/\n/)[13].split[1].to_i
  end
  
  def swap_total
    IO.read('/proc/meminfo').split(/\n/)[14].split[1].to_i
  end
end