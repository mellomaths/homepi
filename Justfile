
connect:
    ./connect.sh

enable-remote-access:
    rpi-connect on

disable-remote-access:
    rpi-connect off

wifi-list:
    @echo 'Listing Wifi networks'
    sudo nmcli dev wifi list

wifi-connect ssid password name:
    sudo nmcli --ask dev wifi connect '{{ssid}}' password {{password}} name "{{name}}"

network-priority-list:
    nmcli --fields autoconnect-priority,name connection

set-priority name priority:
    sudo nmcli connection modify "{{name}}" connection.autoconnect-priority {{priority}}

# Applications
install name:
    ./apps/{{name}}/.install.sh {{name}}

start name:
    ./apps/{{name}}/.start.sh {{name}}

stop name:
    ./apps/{{name}}/.stop.sh {{name}}

status name:
    ./apps/{{name}}/.status.sh 

apply name:
    ./apps/{{name}}/.apply.sh
