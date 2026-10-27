#!/usr/bin/env bash
# End-to-end test: vote -> redis -> worker -> db
set -euo pipefail

count_votes() {
  docker compose exec -T db psql -U postgres -tAc "SELECT COUNT(*) FROM votes" 2>/dev/null || echo 0
}

BEFORE=$(count_votes)
echo "Votes before: $BEFORE"

echo "Casting a vote..."
curl -sS -X POST --data "vote=b" http://localhost:8080 > /dev/null

echo "Waiting for the worker to save it..."
for i in $(seq 1 30); do
  AFTER=$(count_votes)
  if [ "$AFTER" -gt "$BEFORE" ]; then
    echo "Tests passed: votes went from $BEFORE to $AFTER"
    exit 0
  fi
  sleep 1
done

echo "Tests failed: the vote never reached the database"
docker compose logs worker --tail=30
exit 1
