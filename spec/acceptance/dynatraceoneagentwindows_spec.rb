require 'spec_helper_acceptance'

describe 'dynatraceoneagent class windows', if: os[:family] == 'windows' do
  context 'default parameters in apply' do
    it 'runs successfully' do
      pp = <<-PUPPETCODE
      class { 'dynatraceoneagent':
          tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
          paas_token  => '{your-paas-token}',
      }
      PUPPETCODE
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      # expect no changes
      apply_manifest(pp, catch_changes: true)
      expect(apply_manifest(pp, catch_failures: true).exit_code).to be_zero
    end

    describe service('Dynatrace OneAgent') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
