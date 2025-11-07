#!/bin/bash

# Date utilities for notes management system
# Usage: ./date-utils.sh [command]
# Commands:
#   today-date        - Get today's date (YYYY-MM-DD)
#   today-weekday     - Get today's weekday name
#   current-week      - Get current week number (YYYY-WXX)
#   next-week         - Get next week number (YYYY-WXX)
#   prev-week         - Get previous week number (YYYY-WXX)
#   week-range        - Get current week's Monday-Friday range
#   next-week-range   - Get next week's Monday-Friday range
#   current-quarter   - Get current quarter (YYYY-QX)
#   week-monday       - Get this week's Monday date
#   week-friday       - Get this week's Friday date
#   next-monday       - Get next week's Monday date
#   next-friday       - Get next week's Friday date

case "$1" in
    "today-date")
        date +%Y-%m-%d
        ;;
    "today-weekday")
        date +%A
        ;;
    "current-week")
        # Use ISO week numbering (Monday as first day)
        date +%Y-W%V
        ;;
    "next-week")
        date -v+1w +%Y-W%V
        ;;
    "prev-week")
        date -v-1w +%Y-W%V
        ;;
    "week-range")
        monday=$(date -v-monday +%Y-%m-%d)
        friday=$(date -v-monday -v+4d +%Y-%m-%d)
        echo "$monday ~ $friday"
        ;;
    "next-week-range")
        monday=$(date -v+1w -v-monday +%Y-%m-%d)
        friday=$(date -v+1w -v-monday -v+4d +%Y-%m-%d)
        echo "$monday ~ $friday"
        ;;
    "current-quarter")
        month=$(date +%m)
        year=$(date +%Y)
        if [ $month -le 3 ]; then
            echo "${year}-Q1"
        elif [ $month -le 6 ]; then
            echo "${year}-Q2"
        elif [ $month -le 9 ]; then
            echo "${year}-Q3"
        else
            echo "${year}-Q4"
        fi
        ;;
    "week-monday")
        date -v-monday +%Y-%m-%d
        ;;
    "week-friday")
        date -v-monday -v+4d +%Y-%m-%d
        ;;
    "next-monday")
        date -v+1w -v-monday +%Y-%m-%d
        ;;
    "next-friday")
        date -v+1w -v-monday -v+4d +%Y-%m-%d
        ;;
    *)
        echo "Usage: $0 [command]"
        echo ""
        echo "Available commands:"
        echo "  today-date        - Get today's date (YYYY-MM-DD)"
        echo "  today-weekday     - Get today's weekday name"
        echo "  current-week      - Get current week number (YYYY-WXX)"
        echo "  next-week         - Get next week number (YYYY-WXX)"
        echo "  prev-week         - Get previous week number (YYYY-WXX)"
        echo "  week-range        - Get current week's Monday-Friday range"
        echo "  next-week-range   - Get next week's Monday-Friday range"
        echo "  current-quarter   - Get current quarter (YYYY-QX)"
        echo "  week-monday       - Get this week's Monday date"
        echo "  week-friday       - Get this week's Friday date"
        echo "  next-monday       - Get next week's Monday date"
        echo "  next-friday       - Get next week's Friday date"
        echo ""
        echo "Examples:"
        echo "  $0 current-week     # 2025-W30"
        echo "  $0 week-range       # 2025-07-21 ~ 2025-07-25"
        echo "  $0 today-date       # 2025-07-19"
        ;;
esac