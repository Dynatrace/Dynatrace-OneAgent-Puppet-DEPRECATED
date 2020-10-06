# Changelog

All notable changes to this project will be documented in this file.

## Release 1.3.0

### Features

TBD

### Bugfixes

- Add proxy_server var to init.pp

### Known Issues

TBD

## Release 1.2.0

### Features

- Add proxy server resource for archive module

### Bugfixes

TBD

### Known Issues

TBD

## Release 1.1.0

### Features

TBD

### Bugfixes

- Fix config directory dependency issue by installing OneAgent package in install.pp

### Known Issues

TBD

## Release 1.0.0

### Features

- Ability to set string values to the hostcustomproperties.conf and hostautotag.conf of the OneAgent config to add tags and metadata to a host entity.
- Ability to override the automatically detected hostname by setting the values of the hostname.conf file and restarting the Dynatrace OneAgent service.

### Bugfixes

- Remove debug message for whenever reboot parameter was set to false

### Known Issues

TBD

## Release 0.5.0

### Features

- Ability to download specific version
- Module will automatically detect OS and download required installer
- Module will automatically detect OS and will run the installer package required
- Add AIX support
- Add support for OneAgent Install Params
- Implement Archive module for OneAgent installer downloads
- Reboot functionality included
- Module built and validated with PDK

### Bugfixes

- Fix OneAgent download issue
- Fix module directory issue

### Known Issues

TBD
