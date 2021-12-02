# Flask blog API, yet again

This time, implementation of DSs, and using the same in the API.  
Some things got clear, like how to use venv insted of conda, saving 16Gbs data!

```bash
python3 -m venv ./.my-venv
source ./.my-venv/bin/activate # to activate the virtualenv
```

Using SQLite3 was a breeze and what I always wanted, a file to save a DB, and not something I can't see/alter easily.

Use [DB Browser](sqlitebrowser.org) for a more solid view of DB as a GUI, it's quite intuitive.

Use Postman's collection feature to make a well, collection of requests to check for routes of your API.

```bash
pip freeze > requirements.txt
```

Use this to save all dependencies if the venv is active.
