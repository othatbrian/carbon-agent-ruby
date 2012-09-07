require 'net/http'

class MetricNotAvailable < RuntimeError
end

module Metrics
  def apache_active_workers
    from_apache_mod_status("BusyWorkers").to_i
  end

  def apache_idle_workers
    from_apache_mod_status("IdleWorkers").to_i
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

  private

  def from_apache_mod_status(string)
    begin
      response = Net::HTTP.get_response('localhost', '/server-status?auto')
      if response.code == '200' then
        response.body.split(/\n/).detect {|line| line =~ /^#{Regexp.quote(string)}: (.*)/}
        $1
      else
        raise MetricNotAvailable
      end
    rescue Errno::ECONNREFUSED
      raise MetricNotAvailable
    end
  end
end
