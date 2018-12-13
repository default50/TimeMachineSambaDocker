#!/bin/sh

#defaults
TM_USER="${TM_USER:-timemachine}"
TM_GROUP="${TM_GROUP:-timemachine}"
TM_PWD="${TM_PWD:-timemachine}"
TM_UID="${TM_UID:-1000}"
TM_GID="${TM_GID:-1000}"
TM_SIZE="${TM_SIZE:-512000}"

#Add local user, group and set SMB user
grep -q "^${TM_GROUP}:" /etc/group ||
    /usr/sbin/groupadd ${TM_GID:+-g $TM_GID} "${TM_GROUP}"
grep -q "^${TM_USER}:" /etc/passwd ||
    /usr/sbin/useradd -M -s /bin/sh ${TM_GID:+-g $TM_GID} ${TM_UID:+-u $TM_UID} "${TM_USER}"
echo -e "${TM_PWD}\n${TM_PWD}" | smbpasswd -s -a "${TM_USER}"

## timemachine location
if [ ! -d "/timemachine" ]; then
    mkdir "/timemachine"
fi

chown -R ${TM_USER} "/timemachine"
TM_SIZE=$(($TM_SIZE * 1000000))
sed "s#REPLACE_TM_SIZE#${TM_SIZE}#" /tmp/template_quota > /timemachine/.com.apple.TimeMachine.quota.plist

# run CMD
exec "${@}"
