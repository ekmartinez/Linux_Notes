
# Django Startup Steps

Create a virtual environment:

```bash
python -m venv env
```

Install django:

```bash
pip install django
```

Verify version:

```bash
 python -m django --version
```

Create project:

```bash
django-admin startproject project_name
```

Create an app:

```bash
python manage.py startapp app_name
```
Start development server:

```bash
python manage.py runserver
```

Create initial database:

```bash
python manage.py migrate
```

Register App:

```bash
INSTALLED_APPS = [
    "app_name",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
]
```
