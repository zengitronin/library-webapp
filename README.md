# library-webapp

Library Web app


## dev

```sh
cd /path/to/library_webapp

poetry run fastapi dev library_webapp/main.py
```

```sh
curl -X POST http://localhost:8000/authors/ -H 'Content-Type: application/json -d '{"name": "Zsolti"}'
curl -X GET http://localhost:8000/authors/

curl -X GET http://localhost:8000/books/
```
