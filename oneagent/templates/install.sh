#!/bin/bash
#
# Installs the ruxit linux agent 
#

INSTALLER_DIR=<%= @install_dir %>
INSTALLER=<%= @installer %>

CHMOD=`/usr/bin/which chmod`
CHOWN=`/usr/bin/which chown`

#fix permissions
$CHMOD 774 $INSTALLER_DIR/$INSTALLER
$CHOWN -R <%= @user %>:<%= @group %> $INSTALLER_DIR

$INSTALLER_DIR/$INSTALLER
if [ $? -ne 0 ]; then
    echo "Error while installing oneAgent!"
    exit 1
else
	echo "Install of oneAgent succeeded!"
fi

exit 0
