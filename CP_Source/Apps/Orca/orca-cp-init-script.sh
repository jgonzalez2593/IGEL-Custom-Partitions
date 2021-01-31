#! /bin/bash
#set -x
#trap read debug

ACTION="custompart-orca_${1}"

# mount point path
MP=$(get custom_partition.mountpoint)

# custom partition path
CP="${MP}/orca"

# output to systemlog with ID amd tag
LOGGER="logger -it ${ACTION}"

echo "Starting" | $LOGGER

case "$1" in
init)
  # Linking files and folders on proper path
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    if [ ! -z "${DEST}" -a ! -e "${DEST}" ]; then
      # Remove the last slash, if it is a dir
      [ -d $LINE ] && DEST=$(echo "${DEST}" | sed -e "s/\/$//g") | $LOGGER
      if [ ! -z "${DEST}" ]; then
        ln -sv "${LINE}" "${DEST}" | $LOGGER
      fi
    fi
  done

  py3compile /usr/lib/python3/dist-packages/pyatspi | $LOGGER
  py3compile /usr/lib/python3/dist-packages/cairo | $LOGGER
  py3compile /usr/lib/python3/dist-packages/louis | $LOGGER
  py3compile /usr/lib/python3/dist-packages/louis | $LOGGER
  py3compile /usr/lib/python3/dist-packages/orca | $LOGGER
  py3compile /usr/lib/python3/dist-packages/speechd | $LOGGER
  py3compile /usr/lib/python3/dist-packages/speechd_config | $LOGGER
  /usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas

;;
stop)
  # unlink linked files
  find ${CP} | while read LINE
  do
    DEST=$(echo -n "${LINE}" | sed -e "s|${CP}||g")
    unlink $DEST | $LOGGER
  done

;;
esac

echo "Finished" | $LOGGER

exit 0
