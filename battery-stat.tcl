#!/usr/bin/wish

package require Tk

pack [label .l -textvariable power -font "arial 24"]

proc get_stat {} {
	global status
	set f [open /sys/class/power_supply/BAT1/charge_full]
	set charge_full [read $f]
	close $f
	set f [open /sys/class/power_supply/BAT1/charge_now]
	set charge_now [read $f]
	close $f
	set f [open /sys/class/power_supply/BAT1/status]
	set status [string trim [read $f]]
	close $f
	return [expr $charge_now*100/$charge_full]
}

proc loop {} {
	global power status
	set p [get_stat]
	if {$p < 6 && $status != "Charging"} {
		.l configure -foreground red
		catch {exec mplayer /usr/share/audio/2barks.au}
		tk_messageBox -icon warning -detail "Battery Low" -title "Battery Stat"
	} else {
		.l configure -foreground green
	}
	set power "Battery: $p%"
	after 10000 loop
}

loop
bind . <Destroy> {catch {exec mplayer /usr/share/audio/leave.wav}}