
wifi-list:
    @echo 'Listing Wifi networks'
    sudo nmcli dev wifi list

wifi-connect:
    sudo nmcli --ask dev wifi connect 'SSID' password PASSWORD name "NAME"

conn-priority-list:
    nmcli --fields autoconnect-priority,name connection

set-priority:
    sudo nmcli connection modify "NAME" connection.autoconnect-priority PRIORITY

