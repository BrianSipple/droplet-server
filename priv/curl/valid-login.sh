# Values are meant to correspond to the data seeded by /priv/repo/seeds.exs

curl -X POST \
  -H "Content-type: application/json" \
  -d '{
    "grant_type": "password",
    "session": {
      "identification": "bsipple",
      "password": "testPassword123"
    }
  }' \
  http://localhost:4000/api/v1/token
