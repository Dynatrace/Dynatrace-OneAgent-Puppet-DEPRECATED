#!/usr/bin/env bash

### Install required gem files
pdk bundle install

### Start acceptance test environment
pdk bundle exec rake 'litmus:provision_list[vagrant]'

### Install puppet agent
pdk bundle exec rake litmus:install_agent

### This calls a bolt task directly and references the inventory.yaml file that litmus generates in the provision stage.
pdk bundle exec bolt task run provision::fix_secure_path --modulepath spec/fixtures/modules -i inventory.yaml -t ssh_nodes

### Confirm puppet agent is installed
pdk bundle exec bolt command run 'puppet --version' -t all -i inventory.yaml

### Install required archive module
pdk bundle exec bolt command run 'puppet module install puppet-archive --version 4.6.0' -t all -i inventory.yaml

### Install required reboot module
pdk bundle exec bolt command run 'puppet module install puppetlabs-reboot --version 3.2.0' -t all -i inventory.yaml

### Install dynatraceoneagent module
pdk bundle exec rake litmus:install_module

### Check installed modules on target nodes
pdk bundle exec bolt command run 'puppet module list' -t all -i inventory.yaml

### Run acceptance tests
pdk bundle exec rake litmus:acceptance:parallel

### Delete test environment
# pdk bundle exec rake litmus:tear_down

# Run against a single host
# TARGET_HOST=127.0.0.1:2222 pdk bundle exec rspec ./spec/acceptance
