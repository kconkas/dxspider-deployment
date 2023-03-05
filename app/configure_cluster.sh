#!/bin/sh

#   Copyright 2023 Kristijan Conkas (M0NCK), Yiannis Panagou (SV5FRI), and Brian Stucker (KB2S)
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#
#   Configure DxSpider installation
#

# Configure the basic cluster settings.

configure_dxvars() {
 cp $SPIDER_INSTALL_DIR/perl/DXVars.pm.issue $SPIDER_INSTALL_DIR/local/DXVars.pm
 chr="\""

 # Call signs and Locator should be all upper case
 CLUSTER_CALLSIGN=$(echo ${CLUSTER_CALLSIGN} | tr '[a-z]' '[A-Z]')
 CLUSTER_SYSOP_CALLSIGN=$(echo ${CLUSTER_SYSOP_CALLSIGN} | tr '[a-z]' '[A-Z]')
 CLUSTER_LOCATOR=$(echo ${CLUSTER_LOCATOR} | tr '[a-z]' '[A-Z]')

 # Escape e-mail addresses to avoid Perl warnings
 CLUSTER_SYSOP_EMAIL=$(echo ${CLUSTER_SYSOP_EMAIL} | sed 's/\@/\\\\@/g')
 CLUSTER_SYSOP_BBS_ADDRESS=$(echo ${CLUSTER_SYSOP_BBS_ADDRESS} | sed 's/\@/\\\\@/g')

 echo -e "Cluster callsign: " ${CLUSTER_CALLSIGN}
 sed -i "s/mycall =.*/mycall = ${chr}${CLUSTER_CALLSIGN}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster sysop callsign: " ${CLUSTER_SYSOP_CALLSIGN}
 sed -i "s/myalias =.*/myalias = ${chr}${CLUSTER_SYSOP_CALLSIGN}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster sysop name: " ${CLUSTER_SYSOP_NAME}
 sed -i "s/myname =.*/myname = ${chr}${CLUSTER_SYSOP_NAME}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster sysop email: " ${CLUSTER_SYSOP_EMAIL}
 sed -i "s/myemail =.*/myemail = ${chr}${CLUSTER_SYSOP_EMAIL}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster sysop BBS address: " ${CLUSTER_BBS_ADDRESS}
 sed -i "s/mybbsaddr =.*/mybbsaddr = ${chr}${CLUSTER_BBS_ADDRESS}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster latitude in decimal degrees (+ North / - South): " ${CLUSTER_LATITUDE}
 sed -i "s/mylatitude =.*/mylatitude = ${chr}${CLUSTER_LATITUDE}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster longitude in decimal degrees (+ East / - West): " ${CLUSTER_LONGITUDE}
 sed -i "s/mylongitude =.*/mylongitude = ${chr}${CLUSTER_LONGITUDE}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster Maidenhead grid locator: " ${CLUSTER_LOCATOR}
 sed -i "s/mylocator =.*/mylocator = ${chr}${CLUSTER_LOCATOR}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster QTH (roughly): " ${CLUSTER_QTH}
 sed -i "s/myqth =.*/myqth = ${chr}${CLUSTER_QTH}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm

 echo -e "Cluster language: " ${CLUSTER_LANG}
 sed -i "s/lang =.*/lang = ${chr}${CLUSTER_LANG}${chr};/" $SPIDER_INSTALL_DIR/local/DXVars.pm
}

# Generate the Listeners.pm file for the container
configure_listeners(){
 cp $SPIDER_INSTALL_DIR/perl/Listeners.pm $SPIDER_INSTALL_DIR/local/Listeners.pm

cat << EOF > ${SPIDER_INSTALL_DIR}/local/Listeners.pm
package main;
use vars qw(@listen);
@listen = (
    ["0.0.0.0", 7300],
);

1;
EOF
}

configure_cluster(){
 echo -e "Generating basic sysop user file." 
 $SPIDER_INSTALL_DIR/perl/create_sysop.pl
}

main() {
 configure_dxvars
 configure_listeners
 configure_cluster

 echo -e "Completed configuration."
}

main
exit 0
