# Get the installed version for the ruxit agent.
#
# The binaries.json file contains the valid version since spring 51, older versions report all the same version
# The registry aproach for windows can not be used as the registry shows another version than the binary.json *sigh*

require 'json'
require 'facter'
require 'puppet'

Facter.add(:ruxit_installed_version) do
	setcode do
	  version = nil
	  file = nil
	  os_key = nil
    if Facter.value('kernel').eql? 'windows'
      if Facter.value('architecture').eql? 'x64'
        file = 'C:/Program Files (x86)/ruxit/agent/conf/binaries.json'
        os_key = 'windows-x86-32'
      else
        file = 'C:/Program Files/ruxit/agent/conf/binaries.json'
        os_key = 'windows-x86-64'
      end
    elsif Facter.value('kernel').eql? 'Linux'
      file = '/opt/ruxit/agent/conf/binaries.json'
      if Facter.value('architecture').eql? 'x64'
        os_key = 'linux-x86-64'
      else
        os_key = 'linux-x86-32'
      end
    elsif Facter.value('kernel').eql? 'AIX'
      file = '/opt/dynatrace/oneagent/agent/conf/binaries.json'
      if Facter.value('architecture').eql? 'x64'
        os_key = 'aix-ppc-64'
      else
        os_key = 'aix-ppc-32'
      end
    end
    if nil != file
      begin
        if File.exists?(file)
          if File.stat(file).size < (1024 * 15) # don't read files larger than 15KB
            begin
              file_content = File.read(file)
            rescue IOError => e
              raise "IO error: #{e.inspect}"
            end
            hash = JSON.parse(file_content)
            if hash != nil
              # check the installer version for the java installer
              if hash.keys.include? 'os'
                  version = hash['os']['main'][os_key]['installer-version']
              else
                raise 'JSON does not contain expected values'
              end # hash.keys.include 'os'
            else
              raise 'parsing failed'
            end # hash != nil
          else
            raise "#{file} too big for parsing"
          end # check file size
        else
          raise "#{file} not available"
        end # file exists
      rescue StandardError => ex
        Puppet.debug("Unable to determine installed ruxit agent version - #{ex}")
      end
    end # kernel check
    # fallback so we don't have to check for undefined values in puppet
    if nil == version
      version = '0.0.0.0'
    end
    Puppet.info("Installed ruxit agent version -> '#{version}'")
		version
	end
end
