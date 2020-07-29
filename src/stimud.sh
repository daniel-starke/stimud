#!/bin/sh
# @file stimud.sh
# @author Daniel Starke
# @copyright Copyright 2020 Daniel Starke
# @date 2020-03-29
# @version 2020-07-28

function ExitError() {
   local EXIT_CODE="${1}"
   shift 1
   local MESSAGE="${*}"
   echo "Error: ${MESSAGE}"
   umount /media >/dev/null 2>/dev/null
   exit ${EXIT_CODE}
}

# set to 1 if the used button uses complementary code instead of real code
COMPLEMENTARY=0

# set configuration defaults
PARAM_FS="exfat"
for i in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do
   eval "PARAM_IMG_${i}="
   eval "PARAM_CFG_${i}=removable"
done

# read configuration
if [ -f "${CFG}" ]; then
   PARSED_CFG=$(cat <<_CFG
$(tr '\r' '\n' < ${CFG} | tr -d ' \t' | sed -n '/^\(COMPLEMENTARY\|FS\|\(IMG\|CFG\)_[0-9A-F]\)=.*$/p' | sed 's/^/PARAM_/g; s/=/="/g; s/$/"/g')
_CFG
)
   eval "${PARSED_CFG}"
   unset PARSED_CFG
fi

for i in 0 1 2 3 4 5 6 7 8 9 A B C D E F; do
   [ "x$(eval echo \"\${PARAM_CFG_${i}}\")" != "x" ] && eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}},\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//ro,/ro=y }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//cdrom,/cdrom=y }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//removable,/removable=y }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//nofua,/nofua=y }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//nostall,/stall=n }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//stall,/stall=y }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}//,/ }\""
   eval "PARAM_CFG_${i}=\"\${PARAM_CFG_${i}%% }\""
done

case "_${PARAM_COMPLEMENTARY}" in
_|_[dD][eE][fF][aA][uU][lL][tT])
   # use default
   ;;
_1|_[tT][rR][uU][eE]|_[yY][eE][sS])
   COMPLEMENTARY=1
   ;;
_0|_[fF][aA][lL][sS][eE]|_[nN][oO])
   COMPLEMENTARY=0
   ;;
*)
   ExitError ${E_INVALID_CONFIG} "Invalid value passed to COMPLEMENTARY: '${PARAM_COMPLEMENTARY}'."
   ;;
esac

case "_${PARAM_FS}" in
_fat)
   FORMAT_CMD="mkfs -t vfat \"${SD2}\""
   PARTITION_TYPE="c"
   ;;
_exfat)
   FORMAT_CMD="mkfs -t exfat \"${SD2}\""
   PARTITION_TYPE="7"
   ;;
_ntfs)
   FORMAT_CMD="mkfs -t ntfs \"${SD2}\""
   PARTITION_TYPE="7"
   ;;
_ext3)
   FORMAT_CMD="mkfs -t ext3 \"${SD2}\""
   PARTITION_TYPE="83"
   ;;
_ext4)
   FORMAT_CMD="mkfs -t ext4 \"${SD2}\""
   PARTITION_TYPE="83"
   ;;
*)
   ExitError ${E_INVALID_CONFIG} "Invalid file system given: '${PARAM_FS}'."
   ;;
esac

# add and format partition 2 if not present
if [ ! -e "${SD2}" ]; then
   (
      echo n # add a new partition
      echo p # primary partition
      echo 2 # partition number
      echo 18432 # first sector
      echo   # last sector (accept default)
      echo t # change the partition type
      echo 2 # partition number
      echo ${PARTITION_TYPE}
      echo w # write changes
   ) | fdisk "${SD}" || ExitError ${E_FAILURE} "Failed to add partition 2 to SD card."
   sync
   sleep 1
   eval "${FORAMT_CMD}" || ExitError ${E_FAILURE} "Failed to format partition 2 on SD card as ${PARAM_FS}."
   sync
fi

# mount partition 2 on /media
umount /media >/dev/null 2>/dev/null
mount -t auto -o sync "${SD2}" /media \
|| mount -t exfat -o sync "${SD2}" /media \
|| mount -t ntfs-3g -o sync "${SD2}" /media \
|| ExitError ${E_FAILURE} "Failed to mount partition 2 from SD card."

# determine selected configuration
## disable LED driver
echo -n leds > /sys/bus/platform/drivers/leds-gpio/unbind
## prepare GPIO pins
${GPIO} m ou ${SWC}
${GPIO} m iu ${SW1} ${SW2} ${SW4} ${SW8}
## get current rotary switch state (pull-up, active low)
${GPIO} c ${SWC}
usleep 10000 # wait 10ms to let the signal levels settle
if [ "${COMPLEMENTARY}" -ne 1 ]; then
   VAL_1="$(${GPIO} g ${SW1} | tr -d '\r\n' | tr '01' '10')"
   VAL_2="$(${GPIO} g ${SW2} | tr -d '\r\n' | tr '01' '10')"
   VAL_4="$(${GPIO} g ${SW4} | tr -d '\r\n' | tr '01' '10')"
   VAL_8="$(${GPIO} g ${SW8} | tr -d '\r\n' | tr '01' '10')"
else
   VAL_1="$(${GPIO} g ${SW1} | tr -d '\r\n')"
   VAL_2="$(${GPIO} g ${SW2} | tr -d '\r\n')"
   VAL_4="$(${GPIO} g ${SW4} | tr -d '\r\n')"
   VAL_8="$(${GPIO} g ${SW8} | tr -d '\r\n')"
fi
if [ "x${BOARD_REV}" = "xC" ]; then
	# special handling for SW2 in rev. C due to installed pull-down on PB4
   ${GPIO} m od ${SWC}
   ${GPIO} m iu ${SW4}
	${GPIO} s ${SWC}
	usleep 10000 # wait 10ms to let the signal levels settle
   if [ "${COMPLEMENTARY}" -eq 1 ]; then # inverted logic
      VAL_2="$(${GPIO} g ${SW2} | tr -d '\r\n' | tr '01' '10')"
   else
      VAL_2="$(${GPIO} g ${SW2} | tr -d '\r\n')"
   fi
fi
let "VALUE = (8 * VAL_8) + (4 * VAL_4) + (2 * VAL_2) + VAL_1"
## convert value to hex digit
SELECTED="$(printf "%X" "${VALUE}")"
## release GPIO pins
${GPIO} m - ${SWC} ${SW1} ${SW2} ${SW4} ${SW8}
## re-enable LED driver
echo -n leds > /sys/bus/platform/drivers/leds-gpio/bind

# provide configured image as USB mass storage
eval "SEL_IMG=\"\${PARAM_IMG_${SELECTED}}\""
eval "SEL_CFG=\"\${PARAM_CFG_${SELECTED}}\""
if [ "x${SEL_IMG}" != "x" -a "x${SEL_IMG:0:1}" != "x/" ]; then
   SEL_IMG="/media/${SEL_IMG}"
fi
if [ "x${SEL_IMG}" = "x" ]; then
   # no image selected => provide whole disk
   umount /media >/dev/null 2>/dev/null
   modprobe g_mass_storage "file=${SD}" ${DEVID} ${SEL_CFG} || ExitError ${E_INVALID_CONFIG} "Invalid configuration given in CFG_${SELECTED}."
elif [ -b "${SEL_IMG}" ]; then
   umount /media >/dev/null 2>/dev/null
   modprobe g_mass_storage "file=${SEL_IMG}" ${DEVID} ${SEL_CFG} || ExitError ${E_INVALID_CONFIG} "Invalid configuration given in CFG_${SELECTED}."
elif [ -f "${SEL_IMG}" ]; then
   modprobe g_mass_storage "file=${SEL_IMG}" ${DEVID} ${SEL_CFG} || ExitError ${E_INVALID_CONFIG} "Invalid configuration given in CFG_${SELECTED}."
else
   ExitError ${E_INVALID_CONFIG} "Configured image file IMG_${SELECTED} '${SEL_IMG}' not found."
fi

exit ${E_SUCCESS}
