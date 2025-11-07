# Notes Repository Structure

This is a personal notes repository organized by time periods.

## Folder Structure

- `.templates/` - Template files for creating new notes
  - `quarterly.md` - Template for quarterly notes
  - `weekly.md` - Template for weekly notes with backlog and daily to-do/done sections
- `.vscode/` - VS Code configuration
- `archives/` - Archived notes and old content
- `reviews/` - Performance reviews and feedback

## File Naming Convention

- `YYYY.md` - Annual notes (e.g., `2025.md`)
- `YYYY-QX.md` - Quarterly notes (e.g., `2025-Q1.md`)
- `YYYY-WXX.md` - Weekly notes (e.g., `2025-W08.md`)

## Weekly Notes Structure

Weekly notes include:

- Period dates (Monday to Friday work week)
- Backlog section for task management
- Daily sections for Monday through Friday
- Summary section for weekly reflection

**Important:** Weekly notes cover Monday-Friday only (5-day work week).

### Task Management Best Practices

- Keep main task items stable - avoid constantly changing the task description
- Use sub-items (indented with `- [x]` or `- [ ]`) to track progress and updates under the main task
- This maintains a clear audit trail while showing progress
- Use strikethrough (`~~text~~`) for tasks that become irrelevant or are completed by others, rather than checking them off
- Only check off tasks (`- [x]`) that you personally completed
- **When updating the status or leaving a log for a task, always add it as an indented sub-item (e.g., `  - waiting for review`), not by editing the main task description.**

## Usage

Use the templates in `.templates/` to create new quarterly and weekly notes following the established structure.

## Date Utilities

The `date-utils.sh` script provides consistent date calculations for note management:

```bash
./date-utils.sh current-week      # Get current week (e.g., 2025-W29)
./date-utils.sh next-week         # Get next week (e.g., 2025-W30)
./date-utils.sh week-range        # Get current week range (e.g., 2025-07-14 ~ 2025-07-18)
./date-utils.sh next-week-range   # Get next week range (e.g., 2025-07-21 ~ 2025-07-25)
./date-utils.sh today-date        # Get today's date (e.g., 2025-07-19)
./date-utils.sh current-quarter   # Get current quarter (e.g., 2025-Q3)
```

Use these commands instead of manual date calculations to ensure consistency across all note operations.

## Agent Commands

### ":help"

When the user says ":help":
Show all available custom commands:

- `:help` - Show all available commands
- `:tasks` - Show today's remaining tasks
- `:start this week` - Create a new weekly note and link it to the quarterly note
- `:start today` - Plan today's tasks by reviewing incomplete items and asking planning questions
- `:wrap up today` - Summarize today's GitHub activities and reflect on the day
- `:wrap up this week` - Summarize the week's GitHub activities, create next week's note, and migrate incomplete tasks

### ":tasks"

When the user says ":tasks":

1. Run `./date-utils.sh current-week` to get the current week
2. Run `./date-utils.sh today-date` to get today's date
3. Find the current week's note file
4. Identify today's section based on the current date
5. Show all incomplete tasks (unchecked `- [ ]` items) from today's section
6. Also show completed tasks (checked `- [x]` items) from today for context

### ":start this week"

When the user says ":start this week":

### ":start today"

When the user says ":start today":

1. Run `./date-utils.sh current-week` and `./date-utils.sh today-date` to get current week and date
2. Read the current week's note file
3. Identify incomplete tasks from today's section and earlier in the week
4. Analyze the context and ask relevant, context-aware planning questions one by one (not all at once):

   **Context Analysis Guidelines:**

   - Review incomplete tasks from previous days and identify blockers or dependencies
   - Check for open PRs that need follow-up or reviews
   - Look for tasks marked as "waiting for X" to follow up on
   - Consider day of the week (Friday = wrap-up considerations, Monday = week planning)
   - Check for urgent items or deadlines mentioned in recent notes
   - Review performance feedback areas that haven't been addressed recently

   **Example Context-Aware Questions:**

   - "It's Friday - should we plan any end-of-week cleanup or preparation for next week?"
   - "You haven't worked on UI expertise sharing lately (from your performance feedback) - any opportunities today?"

5. Wait for user responses to each question before proceeding
6. Help plan and organise today's tasks based on their answers and the identified context

### ":wrap up today"

When the user says ":wrap up today":

1. Run the `./github-activity.sh 2>&1` script to fetch today's GitHub activities
2. Read the current week's note file and identify today's section
3. Analyse the context and ask relevant reflection questions based on what actually happened:

   **Context Analysis Guidelines:**

   - Compare planned tasks vs. completed tasks
   - Identify any blockers or unexpected issues that came up
   - Check if any PRs need follow-up or are waiting for reviews
   - Look for dependencies on other people that should be tracked
   - Consider what preparation might be needed for tomorrow
   - Reference performance feedback goals when relevant

   **Example Context-Aware Questions:**

   - "You planned to finish PR #22744 but it's still open - what prevented completion?"
   - "Three PRs got merged today - do any need follow-up work or monitoring?"
   - "You mentioned waiting for Alex yesterday and didn't follow up - should we add that to tomorrow?"
   - "The chart comparison task was completed - did you find any issues that need addressing?"
   - "It's Thursday - any preparation needed for tomorrow's end-of-week tasks?"

4. Update today's summary section with GitHub activities and reflection notes
5. Help identify priorities and blockers for tomorrow based on the discussion

### ":wrap up this week"

When the user says ":wrap up this week":

1. Run the `./github-activity-week.sh 2>&1` script to fetch this week's GitHub activities
2. Find the current week's note file
3. Scan all days in the week for incomplete tasks (unchecked `- [ ]` items)
4. Also check the backlog section for incomplete tasks
5. Analyse the week's context and ask relevant reflection questions:

   **Context Analysis Guidelines:**

   - Review the week's planned vs. actual accomplishments
   - Identify patterns in blockers or recurring issues
   - Check for PRs or tasks that consistently got postponed
   - Look for dependencies on others that need follow-up
   - Consider performance feedback areas that were or weren't addressed
   - Assess if any incomplete tasks are no longer relevant

   **Example Context-Aware Questions:**

   - "The RoutingFormResponseDenormalised backfill has been pending all week - should we escalate this?"
   - "You created 12 PRs this week but TypeScript upgrade keeps getting postponed - is it still a priority?"
   - "Several tasks mention 'waiting for review' - should we follow up on any of these?"
   - "You haven't worked on UI expertise sharing this week (performance feedback) - plan for next week?"

6. Summarize the GitHub activities and add them to the Summary section **including actual PR titles and links for team sharing** (do not group by day - use simple list format)
7. Create a summary of the week's accomplishments and add it to the Summary section
8. Create next week's note using the template from `.templates/weekly.md`
9. Add all incomplete tasks to the backlog section of the new week's note, but intelligently prioritize based on the context analysis
10. Update the period dates in the new weekly file using: `./date-utils.sh next-week-range`
11. Find the current quarterly note and add a link to the new weekly note

## Performance Review Integration

The `reviews/` folder contains performance feedback that should guide daily and weekly planning:

- **During ":start today"**: Occasionally suggest tasks that align with feedback areas for improvement
- **During ":wrap up today"**: When relevant, connect completed work to feedback goals
- **During weekly planning**: Proactively suggest focusing on feedback areas that haven't been addressed recently
- **General guidance**: Reference feedback when user asks for career advice or improvement suggestions
