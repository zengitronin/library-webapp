#/bin/bash

set -e

root=$(realpath $(dirname ${0}))
cd ${root}/..

# remove DB if exists
[ -f library_webapp.db ] && rm library_webapp.db

# start web app
poetry run fastapi dev library_webapp/main.py &

# make sure cleanup at the end
wa_pid=$(echo $!)
trap "kill ${wa_pid}; sleep 3" EXIT

# wait for web app to startup properly
sleep 5

# run API tests
diff <(curl -sSf -X GET http://localhost:8000/authors/ | jq '.') <(echo '[]' | jq '.')
echo "Read all authors empty Passed"

diff <(curl -sSf -X POST http://localhost:8000/authors/ -H 'Content-Type: application/json' -d '{"name": "Zsolti"}' | jq '.') <(echo '{"name": "Zsolti", "id": 1, "books": []}' | jq '.')
echo "Create author Passed"

diff <(curl -sSf -X GET http://localhost:8000/authors/ | jq '.') <(echo '[{"name": "Zsolti", "id": 1, "books": []}]' | jq '.')
echo "Read all authors Passed"

diff <(curl -sSf -X GET http://localhost:8000/books/ | jq '.') <(echo '[]' | jq '.')
echo "Read all books empty Passed"
