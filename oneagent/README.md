## Overview

This module downloads and installs the [dynatrace](http://www.dynatrace.com/) unified agent on windows and linux systems.

### Sample Usage

#### Example 1
```puppet
class{ 'oneagent':
       download_link => 'https://12tenant34.sprint.dynatracelabs.com/installer/oneagent/unix/latest/12token34',
     }
```
This example will download the dynatrace one agent and connect it to the given dynatrace tenant.

##License
This module is provided under BSD-3-Clause license. Please check out the details in the LICENSE.txt

##Reference

###Classes
###oneagent: 
Main class, includes everything else

###Parameters
The following parameters are available in the `oneagent` class:

####`download_link`
The link to dynatrace one agent. You can get your link by following these steps

1. go to your dynatrace environment: https://{tenant}.live.dynatrace.com
2. Click the burger menu in the left upper corner and select **Hosts**
3. Click **Monitor another host** button in the right upper corner.
3. You will see the "Download Dynatrace OneAgent" wizard; select  operation system. 
4  For **Linux** 
   -    You will see the **wget** command line. You can copy Your link.
4. For **Windows**
    - Rightclick on "Download agent.exe" button and select "Copy link address"
5. Use the link it in your puppet config.


####`user`
The owner of files. 
!! This user is not created by this module. Please make sure it exists. !!

####`group`
The group for the owner of files.

####`log_keep_days`
Sets the number of days you want to keep logs.
defaults to 14 days

####`service_restarts` 
String array with services that should be restarted after install/upgrade.
defaults to an empty array -> no additional service restarts

###Resources

####`cleanup_log`
A resource cleaning all files in a given directory that were not modified in the given time frame.

####`install_oneagent`
Installs the agent from and to the paths defined in the main class.

####`restart_services_hook`
This resource is called after the installation of the dynatrace one agent to restart services that should be instrumented.
You can define the services as a parameter of the main class: service_restarts

####`windows_restart_service`
A resource wrapper for service stop and start.

####`windows_restart_service`
A resource starting a given windows service.

####`windows_restart_service`
A resource stopping a given windows service.

## Supported OSes
This module is designed for Windows and Linux systems. 
If it does not work for your environment please get in touch via the project site.
