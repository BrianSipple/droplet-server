# Values are meant to correspond to the data seeded by /priv/repo/seeds.exs
curl \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyMTMiLCJleHAiOjE0NzQ0Mzc4NjYsImlhdCI6MTQ3MTg0NTg2NiwiaXNzIjoiRHJvcGxldCIsImp0aSI6IjVmY2YyZmNiLWU2ZmQtNDg2ZS05MWM4LTU0ZTI2ZDI3NDMxYyIsInBlbSI6e30sInN1YiI6IlVzZXIxMyIsInR5cCI6InRva2VuIn0.tS6hVe7A2UquiuEGKjLqiJPI5IREFOdJ6L2hBkZZeLDB2ZqTFii-PaEgWBq5fV-R_deE0_gXlCP7A6B6AiLoQw" \
  http://localhost:4000/api/v1/users
