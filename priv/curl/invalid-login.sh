curl -X POST \
  -H "Content-type: application/json" \
  -d '{
    "grant_type": "password",
    "username": "bsipple",
    "password": "badGuess"
  }' \
  http://localhost:4000/api/v1/token
