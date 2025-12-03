#!/bin/bash

# List of included classes
included_classes=("neovide" "dev.warp.Warp")
# https://specifications.freedesktop.org/wm-spec/latest/
included_types=("_NET_WM_WINDOW_TYPE_NORMAL")

interval=0.2

while true; do
	for window_class in "${included_classes[@]}"; do
		# Get the current list of visible window IDs
		current_visible_windows=$(xdotool search --class "$window_class" 2>/dev/null)

		# Loop through each window
		for window_id in $current_visible_windows; do
			properties=$(xprop -id "$window_id" _NET_WM_WINDOW_TYPE _KDE_NET_WM_BLUR_BEHIND_REGION 2>/dev/null)
			# If xprop returns nothing, the window might have closed, so skip it.
			if [ -z "$properties" ]; then
				continue
			fi

			window_types_str=""
			current_blur_status="0" # Default to not blurred

			# Parse properties using bash regex matching, avoiding external awk/sed calls.
			while IFS= read -r line; do
				if [[ "$line" =~ _NET_WM_WINDOW_TYPE\(ATOM\)\ =\ (.*) ]]; then
					IFS=', ' read -ra window_types <<<"${BASH_REMATCH[1]}"
				elif [[ "$line" =~ _KDE_NET_WM_BLUR_BEHIND_REGION\(CARDINAL\)\ =\ (.*) ]]; then
					current_blur_status="${BASH_REMATCH[1]}"
				fi
			done <<<"$properties"

			if [ "$current_blur_status" == "1" ]; then
				# Already blurred, skip
				continue
			fi

			# Check if any of the window types are in the included list
			is_included=false
			for wtype in ${window_types[@]}; do
				for included_type in "${included_types[@]}"; do
					if [[ "$wtype" == "$included_type" ]]; then
						is_included=true
						break 2 # Break both loops if a match is found
					fi
				done
			done

			# If not excluded and included, blur the window
			if [ "$is_included" == true ]; then
				xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 1 -id "$window_id"
			fi
		done
	done
	sleep $interval

done
