#!/bin/bash

# GitHub Weekly Activity Summary Script
# Fetches GitHub activities from Monday to today using gh CLI

# Disable pager for gh commands
export GH_PAGER=""

# Calculate Monday of current week
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS date command
    MONDAY=$(date -v-monday +%Y-%m-%d)
else
    # Linux date command
    MONDAY=$(date -d 'monday' +%Y-%m-%d)
fi

TODAY=$(date +%Y-%m-%d)
USERNAME=$(gh api user --jq '.login')

echo "=== GitHub Activity Summary for Week ($MONDAY to $TODAY) ==="
echo "User: $USERNAME"
echo ""

echo "📝 Pull Requests Created This Week:"
gh api "search/issues?q=author:$USERNAME+created:$MONDAY..$TODAY+type:pr+org:zeroheight" --jq '.items[] | "• " + (.created_at | split("T")[0]) + " - " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "💬 Comments Made This Week:"
gh api "search/issues?q=commenter:$USERNAME+created:$MONDAY..$TODAY+org:zeroheight" --jq '.items[] | "• " + (.created_at | split("T")[0]) + " - " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "👀 Reviews Made This Week:"
gh api "search/issues?q=reviewed-by:$USERNAME+updated:$MONDAY..$TODAY+type:pr+org:zeroheight+-author:$USERNAME" --jq '.items[] | "• " + (.updated_at | split("T")[0]) + " - " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "🔄 My Issues/PRs With Activity This Week:"
gh api "search/issues?q=author:$USERNAME+updated:$MONDAY..$TODAY+involves:$USERNAME+org:zeroheight" --jq '.items[] | "• " + (.updated_at | split("T")[0]) + " - " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""



echo "📊 Daily Breakdown:"
# Generate dates from Monday to today
current_date="$MONDAY"
while true; do
    day_name=$(date -j -f "%Y-%m-%d" "$current_date" "+%A" 2>/dev/null || date -d "$current_date" "+%A" 2>/dev/null)
    echo ""
    echo "--- $day_name ($current_date) ---"
    
    # PRs created on this day
    pr_count=$(gh api "search/issues?q=author:$USERNAME+created:$current_date+type:pr+org:zeroheight" --jq '.total_count')
    if [[ $pr_count -gt 0 ]]; then
        echo "  📝 PRs created: $pr_count"
    fi
    
    # Comments made on this day
    comment_count=$(gh api "search/issues?q=commenter:$USERNAME+created:$current_date+org:zeroheight" --jq '.total_count')
    if [[ $comment_count -gt 0 ]]; then
        echo "  💬 Comments made: $comment_count"
    fi
    
    # Reviews made on this day
    review_count=$(gh api "search/issues?q=reviewed-by:$USERNAME+updated:$current_date+type:pr+org:zeroheight+-author:$USERNAME" --jq '.total_count')
    if [[ $review_count -gt 0 ]]; then
        echo "  👀 Reviews made: $review_count"
    fi
    
    if [[ $pr_count -eq 0 && $comment_count -eq 0 && $review_count -eq 0 ]]; then
        echo "  (No GitHub activity)"
    fi
    
    # Check if we've reached today
    if [[ "$current_date" == "$TODAY" ]]; then
        break
    fi
    
    # Increment date by 1 day
    if [[ "$OSTYPE" == "darwin"* ]]; then
        current_date=$(date -j -v+1d -f "%Y-%m-%d" "$current_date" "+%Y-%m-%d")
    else
        current_date=$(date -d "$current_date + 1 day" "+%Y-%m-%d")
    fi
done