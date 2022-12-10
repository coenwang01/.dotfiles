#!/bin/sh

# Select the right temperature file. #
for temp_dir in /sys/class/hwmon/*; do
    [[ "$(< "${temp_dir}/name")" =~ (coretemp|fam15h_power|k10temp) ]] && {

		temp_dirs=("$temp_dir"/temp*_input)
        temp_dir=${temp_dirs[0]}
        break

	}

done


# Get CPU temp. #
[[ -f "$temp_dir" ]] && deg="$(($(< "$temp_dir") * 100 / 10000))"

# Add CPU temp to the output. #
if [[ "$cpu_temp" != "off" && "$deg" ]]; then
    deg="${deg//.}"

    # Convert to Fahrenheit if enabled
    [[ "$cpu_temp" == "F" ]] && deg="$((deg * 90 / 50 + 320))"

	deg_no_format="${deg/${deg: -1}}"

    # Format the output
    deg="${deg/${deg: -1}}°${cpu_temp:-C}"


fi

# from  0°C to 40°C print -> 
if [[ "$deg_no_format" -le 40 ]]
	then
		# the ' %{T3} ' -> pass font type to polybar config file
		# the selected font type is number 3, which is (font-3 = "Iosevka:style=bold:"size=12;3" )
		echo "%{T3} %{F}%{T4}$deg%{T-}"

# from 40°C to 60°C print -> 
elif [[ "$deg_no_format" -le 60 ]]
	then
		echo "%{T3} %{F}%{T4}$deg%{T-}"


# from 60°C to 85°C print -> 
elif [[ "$deg_no_format" -le 85 ]]
	then
		echo "%{T3} %{F}%{T4}$deg%{T-}"

# from 85°C to +... print -> 
elif [[ "$deg_no_format" -gt 85 ]]
	then
		# the  ' -n "%{F#FF0008}"  ' -> red font as 85°C to +... is the default warn temperature
		echo -n "%{T3}%{F#FF0008} %{F#FF0008}%{T4}$deg%{T-}"
fi
