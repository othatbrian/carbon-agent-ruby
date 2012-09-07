require 'test/unit'
require 'flexmock/test_unit'
require_relative '../lib/metrics'

class MetricsTest < Test::Unit::TestCase
  include Metrics
  
  def test_apache_active_workers
    apache_status = mock_data('apache_status.txt')
    response = flexmock(Net::HTTPResponse, :code => '200', :body => apache_status)
    flexmock(Net::HTTP, :get_response => response)
    assert_equal 1, apache_active_workers
  end

  def test_apache_idle_workers
    apache_status = mock_data('/apache_status.txt')
    response = flexmock(Net::HTTPResponse, :code => '200', :body => apache_status)
    flexmock(Net::HTTP, :get_response => response)
    assert_equal 4, apache_idle_workers
  end
  
  def test_apache_mod_status_disabled
    response = flexmock(Net::HTTPResponse, :code => '404')
    flexmock(Net::HTTP, :get_response => response)
    assert_raise(MetricNotAvailable) { apache_active_workers }
  end
  
  def test_apache_not_available
    flexmock(Net::HTTP).should_receive(:get_response).and_raise(Errno::ECONNREFUSED)
    assert_raise(MetricNotAvailable) { apache_active_workers }
  end
  
  def test_load_1m
    assert load_1m =~ /\d\.\d\d/
  end
  
  def test_mem_free
    meminfo = mock_data('meminfo.txt')
    flexmock(IO, :read => meminfo)
    assert_equal 173964, mem_free
  end
  
  def test_mem_total
    meminfo = mock_data('meminfo.txt')
    flexmock(IO).should_receive(:read).with('/proc/meminfo').and_return(meminfo)
    assert_equal 503428, mem_total
  end
  
  def test_swap_free
    meminfo = mock_data('meminfo.txt')
    flexmock(IO).should_receive(:read).with('/proc/meminfo').and_return(meminfo)
    assert_equal 520188, swap_free
  end
  
  def test_swap_total
    meminfo = mock_data('meminfo.txt')
    flexmock(IO).should_receive(:read).with('/proc/meminfo').and_return(meminfo)
    assert_equal 520188, swap_total
  end

  private

  def mock_data(file)
    IO.read File.join(File.dirname(__FILE__), file)
  end
end
