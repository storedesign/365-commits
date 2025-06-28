#!/usr/bin/env bash
_() {
  echo "GitHub Username:"
  read -r USERNAME
  echo "GitHub Access Token (hidden):"
  stty -echo
  read -r TOKEN
  stty echo
  echo
  echo "Repository Name (must already exist):"
  read -r REPO
  echo "Year to fake commits for (e.g. 2000):"
  read -r YEAR
  if [ -z "$USERNAME" ] || [ -z "$TOKEN" ] || [ -z "$REPO" ] || [ -z "$YEAR" ]; then
    echo "All fields are required."
    exit 1
  fi

  # Clone the repo instead of creating a new one
  git clone "https://${TOKEN}@github.com/${USERNAME}/${REPO}.git" "$YEAR"
  cd "$YEAR" || exit 1

  [ -f journal.txt ] || touch journal.txt

  NOTES=(
    "Thought about modularizing config loader."
    "Left TODOs for later. Might not come back."
    "Re-read old code. Confused but impressed."
    "Logged some rough ideas. Not sure they'll work."
    "This code is older than it should be."
  )
  BURNOUTS=(
    "Couldn't focus today."
    "Skipped most of it. Brain was off."
    "Didn't write anything useful."
    "Just staring at the screen."
    "Burned out. Need a break."
  )
  LEARNING=(
    "Read 3 docs. Still confused."
    "Finally understood something from last week."
    "Watched a tutorial. Didn’t follow it exactly."
    "Learning async the hard way."
    "Turns out I misunderstood Promises all this time."
    "Tried something from a blog. Kinda works."
    "Reading specs now. Pray for me."
    "Learning by breaking things. As usual."
    "Followed a YouTube tutorial. Got distracted by the music."
    "StackOverflow taught me something new today."
  )
  EXPERIMENTS=(
    "What if I tried it this way?"
    "Playing with an idea. Might be dumb."
    "Threw together a prototype. It's ugly."
    "Experimental layout. Might ditch it."
    "Testing stuff. Results unclear."
    "Tried a different library. Not sure if better."
    "Code smells, but it's a learning exercise."
    "Hackathon-style coding today."
    "Pushing weird changes for fun."
    "Spaghetti phase. Needs cleanup later."
  )
  INFRA=(
    "Tweaked the CI again. Hope it works now."
    "YAML gods weren’t kind today."
    "Added a dotfile. Feeling powerful."
    "Updated .env.example like a responsible dev."
    "Renamed scripts. It was chaos before."
    "Docker did a thing. I don’t understand it yet."
    "Cleaned up the scripts folder. Was a mess."
    "CI now yells less at me."
    "Refreshed some Makefile voodoo."
    "Removed unnecessary dependencies. Hopefully."
  )
  CLEANUP=(
    "Removed 100 lines of dead code."
    "Re-indented everything. Worth it."
    "Deleted old components no one used."
    "Cleaned up debug logs. I miss them already."
    "Rewrote a function just to sleep better."
    "Commented out chaos. Will revisit later."
    "Removed a TODO from 2022."
    "Removed console.logs. Like a real dev."
    "Linted it all. My eyes hurt."
    "Tidied up the mess I created yesterday."
  )
  FRONTEND=(
    "Tried centering a div. Again."
    "Animations now slightly less janky."
    "Made a button feel clicky. Nice."
    "Responsive now... mostly."
    "Dropdowns behaving today."
    "Forms no longer broken. Big win."
    "Dark mode tweaks. My eyes thank me."
    "CSS grid is magic. Still learning."
    "Alignment is a lie."
    "Finally fixed layout shifting!"
  )
  FUNNY=(
    "Who needs sleep when you have bugs?"
    "Code first, ask questions never."
    "Yeeted some code into production."
    "Commit now, regret later."
    "This is fine. Everything is fine."
    "Fixed one bug, created three."
    "Built with vibes only."
    "Code works. Don’t touch it."
    "It's not a bug, it's a feature."
    "Cowboy coding at its finest."
  )
  CLEAR=(
    "Minor updates."
    "Updated some files."
    "Clean commit."
    "Small improvements."
    "Refactored code."
    "Updated content."
    "Code edit."
    "Polished a few things."
    "Commit for today."
    "General maintenance."
  )

  for i in {0..364}; do
    DATE=$(date -d "$YEAR-01-01 +$i days" +%Y-%m-%d)

    ALL_MESSAGES=(
      "${NOTES[@]}"
      "${BURNOUTS[@]}"
      "${LEARNING[@]}"
      "${EXPERIMENTS[@]}"
      "${INFRA[@]}"
      "${CLEANUP[@]}"
      "${FRONTEND[@]}"
      "${FUNNY[@]}"
      "${CLEAR[@]}"
    )
    INDEX=$((RANDOM % ${#ALL_MESSAGES[@]}))
    MESSAGE="${ALL_MESSAGES[$INDEX]}"
    LOG_ENTRY="$DATE: $MESSAGE"

    # Prevent duplicates and sort all logs
    if [ -f journal.txt ]; then
      grep -v "^$DATE:" journal.txt > temp.txt
      echo "$LOG_ENTRY" >> temp.txt
      sort temp.txt > journal.txt
      rm temp.txt
    else
      echo "$LOG_ENTRY" > journal.txt
    fi

    git add journal.txt

    MONTH_DAY=$(date -d "$DATE" +"%b %d")
    GIT_AUTHOR_DATE="$DATE 12:00:00" \
    GIT_COMMITTER_DATE="$DATE 12:00:00" \
    git commit -m "$MONTH_DAY: $MESSAGE"
  done

  git push -u origin main
  echo
  echo "Done. Check your graph at: https://github.com/${USERNAME}"
} && _
unset -f _
