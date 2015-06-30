# Fact that gets the latest stable version of ruxit agent
require 'facter'
require 'puppet'
require 'net/http'
require 'uri'

Facter.add(:ruxit_latest_version_stable) do
  setcode do
    version = '0.0.0.0'
    begin
      uri = URI('http://download.ruxit.com/agent/latest')
      res = Net::HTTP.get_response(uri)
      version = res.body if res.is_a?(Net::HTTPSuccess)
    rescue StandardError => e
      Puppet.crit("Exception in ruxit_latest_version_stable  -> \n#{e.inspect}")
    end
    Puppet.info("Latest ruxit agent STABLE version  -> '#{version}'")
    version
  end
end
