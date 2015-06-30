#!/bin/bash
#
# Installs the ruxit linux agent 
#

INSTALLER_DIR=<%= @install_dir %>
INSTALLER=<%= @installer %>
SERVER=<%= @ruxit_host %>
TENANT=<%= @ruxit_tenant %>
TOKEN=<%= @ruxit_token %>
PROCESSHOOKING=1

CHMOD=`/usr/bin/which chmod`
CHOWN=`/usr/bin/which chown`

#fix permissions
$CHMOD 774 $INSTALLER_DIR/$INSTALLER
$CHOWN -R <%= @user %>:<%= @group %> $INSTALLER_DIR

$INSTALLER_DIR/$INSTALLER SERVER=$SERVER TENANT=$TENANT PROCESSHOOKING=$PROCESSHOOKING TENANT_TOKEN=$TOKEN
if [ $? -ne 0 ]; then
    echo "Error while installing ruxit agent!"
    exit 1
else
	echo "Install of ruxit agent succeeded!"
fi

exit 0
