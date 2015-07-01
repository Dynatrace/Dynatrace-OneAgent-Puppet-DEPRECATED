# Fact that gets the latest sprint version of ruxit agent
require 'facter'
require 'puppet'
require 'net/http'
require 'uri'

Facter.add(:ruxit_latest_version_sprint) do
  setcode do
    version = '0.0.0.0'
    begin
      uri = URI('http://download-sprint.ruxitlabs.com/agent/unstable/latest')
      res = Net::HTTP.get_response(uri)
      version = res.body if res.is_a?(Net::HTTPSuccess)
    rescue StandardError => e
      Puppet.crit("Exception in ruxit_latest_version_sprint  -> \n#{e.inspect}")
    end
    Puppet.debug("Latest ruxit agent SPRINT version  -> '#{version}'")
    version
  end
end
