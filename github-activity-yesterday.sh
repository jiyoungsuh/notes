#!/bin/bash

# GitHub Activity Summary Script for Yesterday
# Fetches yesterday's GitHub activities using gh CLI

# Disable pager for gh commands
export GH_PAGER=""

YESTERDAY=$(date -v-1d +%Y-%m-%d)
USERNAME=$(gh api user --jq '.login')

echo "=== GitHub Activity Summary for $YESTERDAY ==="
echo "User: $USERNAME"
echo ""

echo "📝 Pull Requests Created Yesterday:"
gh api "search/issues?q=author:$USERNAME+created:$YESTERDAY+type:pr+org:zeroheight" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "💬 Comments Made Yesterday:"
gh api "search/issues?q=commenter:$USERNAME+created:$YESTERDAY+org:zeroheight" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "👀 Reviews Made Yesterday:"
gh api "search/issues?q=reviewed-by:$USERNAME+updated:$YESTERDAY+type:pr+org:zeroheight+-author:$USERNAME" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "🔄 My Issues/PRs With Activity Yesterday:"
gh api "search/issues?q=author:$USERNAME+updated:$YESTERDAY+involves:$USERNAME+org:zeroheight" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'