
# Django Startup 

## Project Creation

Create a virtual environment:

```bash
python -m venv env
```

Activate virtual environment:

```bash
source env/bin/activate
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

Start development server:

```bash
python manage.py runserver
```

Create an app:

```bash
python manage.py startapp app_name
```

Register App:

```bash
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "app_name",
]
```

## MariaDB Setup

Install MariaDB:

```bash
sudo emerge -av dev-db/mariadb
```

Gentoo Linux provides the `--config` option which helps in setting up MariaDb.  It will create a database, set proper permissions, and assist in creating a secure root MariaDB password.

After installing with the above command, Configure the database as follows:

```bash
sudo emerge --config dev-db/mariadb
```

Install mysqlclient:

```bash
pip install mysqlclient
```

In your `settings.py`:

```bash
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'db_name',
        'USER': 'user_name',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '3306',
    },
}
```

Create initial database:

```bash
python manage.py migrate
```

## Django Admin Access

Create User:

```bash
python manage.py createsuperuser
```
```bash
Username: admin
```
```bash
Email address: admin@example.com
```
```bash
Password: **********
Password (again): *********
Superuser created successfully.
```
