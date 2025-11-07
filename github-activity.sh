#!/bin/bash

# GitHub Activity Summary Script
# Fetches today's GitHub activities using gh CLI

# Disable pager for gh commands
export GH_PAGER=""

TODAY=$(date +%Y-%m-%d)
USERNAME=$(gh api user --jq '.login')

echo "=== GitHub Activity Summary for $TODAY ==="
echo "User: $USERNAME"
echo ""

echo "📝 Pull Requests Created Today:"
gh api "search/issues?q=author:$USERNAME+created:$TODAY+type:pr+org:zeroheight" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "💬 Comments Made Today:"
gh api "search/issues?q=commenter:$USERNAME+created:$TODAY+org:zeroheight" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "👀 Reviews Made Today:"
gh api "search/issues?q=reviewed-by:$USERNAME+updated:$TODAY+type:pr+org:zeroheight+-author:$USERNAME" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'
echo ""

echo "🔄 My Issues/PRs With Activity Today:"
gh api "search/issues?q=author:$USERNAME+updated:$TODAY+involves:$USERNAME+org:zeroheight" --jq '.items[] | "• " + .title + " (" + (.repository_url | split("/") | .[-1]) + ") - " + .html_url'