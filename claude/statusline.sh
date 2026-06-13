#!/bin/bash
input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
AGENT_NAME=$(echo "$input" | jq -r '.agent.name // empty')
CONTEXT_USED=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

CACHE_FILE="/tmp/claude_statusline_limits.cache"
NOW=$(date +%s)
FIVE_HOUR_USED=""
SEVEN_DAY_USED=""
CACHE_TIME=0

normalize_pct() {
	local pct=$1
	echo "${pct%.*}"
}

if [[ -f "$CACHE_FILE" ]]; then
	{
		read -r CACHE_TIME
		read -r FIVE_HOUR_USED
		read -r SEVEN_DAY_USED
	} <"$CACHE_FILE"
	FIVE_HOUR_USED=$(normalize_pct "$FIVE_HOUR_USED")
	SEVEN_DAY_USED=$(normalize_pct "$SEVEN_DAY_USED")
fi

if ((NOW - CACHE_TIME >= 60)); then
	FIVE_HOUR_USED=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
	SEVEN_DAY_USED=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
	FIVE_HOUR_USED=$(normalize_pct "$FIVE_HOUR_USED")
	SEVEN_DAY_USED=$(normalize_pct "$SEVEN_DAY_USED")
	printf '%s\n%s\n%s\n' "$NOW" "$FIVE_HOUR_USED" "$SEVEN_DAY_USED" >"$CACHE_FILE"
fi

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

make_bar() {
	local pct=${1%.*}
	local filled=$((pct / 10))
	local bar=""
	for ((i = 0; i < filled; i++)); do bar+="▓"; done
	for ((i = filled; i < 10; i++)); do bar+="░"; done
	echo "$bar"
}

color_pct() {
	local pct=${1%.*}
	if [[ "$pct" -ge 90 ]]; then
		echo "$RED"
	elif [[ "$pct" -ge 50 ]]; then
		echo "$YELLOW"
	else
		echo "$GREEN"
	fi
}

STATUS="🤖 ${MODEL_DISPLAY} |  ${CURRENT_DIR##*/}"

if [[ -n "$AGENT_NAME" ]]; then
	STATUS="${STATUS} | ⚡ ${AGENT_NAME}"
fi

if [[ -n "$CONTEXT_USED" ]]; then
	C=$(color_pct "$CONTEXT_USED")
	BAR=$(make_bar "$CONTEXT_USED")
	STATUS="${STATUS} | 󰆈 ${C}${BAR} ${CONTEXT_USED}%${RESET}"
fi

if [[ -n "$FIVE_HOUR_USED" || -n "$SEVEN_DAY_USED" ]]; then
	LIMITS=""
	if [[ -n "$FIVE_HOUR_USED" ]]; then
		C=$(color_pct "$FIVE_HOUR_USED")
		BAR=$(make_bar "$FIVE_HOUR_USED")
		LIMITS=" ${C}${BAR} ${FIVE_HOUR_USED}%${RESET}"
	fi
	if [[ -n "$SEVEN_DAY_USED" ]]; then
		C=$(color_pct "$SEVEN_DAY_USED")
		BAR=$(make_bar "$SEVEN_DAY_USED")
		LIMITS="${LIMITS:+${LIMITS}  } ${C}${BAR} ${SEVEN_DAY_USED}%${RESET}"
	fi
	STATUS="${STATUS} | ${LIMITS}"
fi

echo -e "$STATUS"
