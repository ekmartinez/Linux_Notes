
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

## Environment Variables

For the sake of best practices it is better to maintain project's sensitive information concealed, `django-environ` helps us do just that.

Install django-environ:

```bash
pip install django-environ
```

Create a `.env` in the root directory of the project:

```bash
SECRET_KEY=django-insecure-728k0bs%91o$^sp%aa_ji@2fmtwpdk7r1na#*$%l2+%)7tnpo3
DB_NAME=your_db_name
DB_USER=your_db_user
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
```

In your `settings.py` file:

```bash
import environ

#Ensue BASE_DIR is defined.
BASE_DIR = Path(__file__).resolve().parent.parent

env = environ.Env()
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

# Your secret key
SECRET_KEY = env("SECRET_KEY")

DATABASES = {
    'default': {
    'ENGINE': 'django.db.backends.postgresql_psycopg2',
    'NAME': env("DB_NAME"),
    'USER': env("DB_USER"),
    'PASSWORD': env("DB_PASSWORD"),
    'HOST': env("DB_HOST"),
    'PORT': env("DB_PORT"),
    }
}
```

Finally, add the `.env` file to your `.gitignore` file:

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
