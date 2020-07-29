#!/bin/sh
# @file start.sh
# @author Daniel Starke
# @copyright Copyright 2020 Daniel Starke
# @date 2020-03-26
# @version 2020-07-28

# define environment
export E_SUCCESS=0
export E_FAILURE=1
export E_INVALID_CONFIG=2
export E_UNKNOWN=99
export LEDR="/sys/class/leds/stimud:red:usr"
export LEDG="/sys/class/leds/stimud:green:usr"
export LEDB="/sys/class/leds/stimud:blue:usr"
export LEDR_MAX=$(cat ${LEDR}/max_brightness)
export LEDG_MAX=$(cat ${LEDG}/max_brightness)
export LEDB_MAX=$(cat ${LEDB}/max_brightness)
export LED_INTVL=500 # ms
export BOARD_REV="A"
export SWC=192
export SW1=193
export SW2=194
export SW4=195
export SW8=196
export APP="/root/stimud.sh"
export CFG="/root/stimud.cfg"
export LOG="/root/stimud.log"
export GPIO="/root/stimud-gpio"
export SD="/dev/mmcblk0"
export SD1="/dev/mmcblk0p1"
export SD2="/dev/mmcblk0p2"
export DEVID="iManufacturer=\"Daniel Starke\" iProduct=STIMUD iSerialNumber=$(grep Serial /proc/cpuinfo | cut -d' ' -f2)"

# usage: SetLED <MODE> <LED_COLOR>
function SetLED() {
   # map LED_COLOR to actual LED
   case "${2}" in
   R*)
      LED_PATH="${LEDR}"
      LED_MAX="${LEDR_MAX}"
      ;;
   G*)
      LED_PATH="${LEDG}"
      LED_MAX="${LEDG_MAX}"
      ;;
   B*)
      LED_PATH="${LEDB}"
      LED_MAX="${LEDB_MAX}"
      ;;
   *)
      return 1
      ;;
   esac
   # apply MODE
   case "${1}" in
   disk-activity)
      echo "${LED_MAX}" > ${LED_PATH}/brightness
      echo mmc0 > ${LED_PATH}/trigger
      ;;
   flushing)
      echo "${LED_MAX}" > ${LED_PATH}/brightness
      echo timer > ${LED_PATH}/trigger
      echo "${LED_INTVL}" > ${LED_PATH}/delay_on
      echo "${LED_INTVL}" > ${LED_PATH}/delay_off
      ;;
   on)
      echo "${LED_MAX}" > ${LED_PATH}/brightness
      echo none > ${LED_PATH}/trigger
      ;;
   *) # off
      echo 0 > ${LED_PATH}/brightness
      echo none > ${LED_PATH}/trigger
      ;;
   esac
}

# usage: ResetLEDs
function ResetLEDs() {
   echo -n leds > /sys/bus/platform/drivers/leds-gpio/bind
   SetLED off RED
   SetLED off GREEN
   SetLED off BLUE
}

# LEDs to "starting" state: green, flushing
ResetLEDs
SetLED flushing GREEN

# overwrite default script and configuration from SD partition 1 if given
mount -t vfat "${SD1}" /mnt
[ -f "/mnt/$(basename "${APP}")" ] && cp "/mnt/$(basename "${APP}")" "${APP}" && chmod 755 "${APP}"
[ -f "/mnt/$(basename "${CFG}")" ] && cp "/mnt/$(basename "${CFG}")" "${CFG}" && chmod 755 "${CFG}"
[ -f "/mnt/$(basename "${LOG}")" ] && rm -f "/mnt/$(basename "${LOG}")" >/dev/null 2>/dev/null
[ ! -f "/mnt/$(basename "${CFG}")" ] && cp "${CFG}" "/mnt/$(basename "${CFG}")"
umount /mnt

if mount -a "${SD2}" /mnt || mount -t exfat "${SD2}" /mnt || mount -t ntfs-3g "${SD2}" /mnt ; then
   [ -f "/mnt/$(basename "${CFG}")" ] && cp "/mnt/$(basename "${CFG}")" "${CFG}" && chmod 755 "${CFG}"
   [ ! -f "/mnt/$(basename "${CFG}")" ] && cp "${CFG}" "/mnt/$(basename "${CFG}")"
   umount /mnt
fi

# run script
eval "${APP}" >${LOG} 2>&1
err=$?

# cleanup any mount point still mounted
umount /mnt

# copy log from script to SD partition 1 on error
case $err in
${E_SUCCESS})
   ;;
*)
   umount /media >/dev/null 2>/dev/null
   mount -t vfat "${SD1}" /mnt && cp "${LOG}" /mnt && umount /mnt
   rmmod g_mass_storage
   modprobe g_mass_storage "file=${SD}" ${DEVID}
   ;;
esac

# set LEDs according to the error state
ResetLEDs
case $err in
${E_SUCCESS})
   # blue, on
   SetLED disk-activity BLUE
   ;;
${E_FAILURE})
   # red, flushing
   SetLED flushing RED
   ;;
${E_INVALID_CONFIG})
   # red / blue, alternating
   SetLED flushing RED
   usleep "${LED_INTVL}000"
   SetLED flushing BLUE
   ;;
*) # E_UNKNOWN
   # red, on
   SetLED on RED
   ;;
esac

