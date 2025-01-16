# Moodle Installation

This section contains instructions on how to install and configure the Moodle LMS hosted locally on Debian 12.

## Installing Dependencies (LAMP Stack)

Update repositories:

```bash
sudo apt update
```

**Apache Web Server**

Installation:

```bash
sudo apt install apache2
```

Verify status:

```bash
sudo systemctl status apache2
```

Enable rewrite module:

```bash
sudo a2enmod rewrite
# You could also enable ssl but 
# it is out of scope right now.
```

Configuration:

```bash
sudo vim /etc/apache2/sites-available/moodle.conf
```
```bash
<VirtualHost *:80>
    ServerAdmin admin@localhost
    DocumentRoot /var/www/html/moodle
    ServerName localhost

    <Directory /var/www/html/moodle>
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/moodle_error.log
    CustomLog ${APACHE_LOG_DIR}/moodle_access.log combined
</VirtualHost>
```

Enable site and restart Apache:

```bash
sudo a2ensite moodle.conf
sudo systemctl restart apache2
```

**MariaDB**

Install mariadb:

```bash
sudo apt install mariadb-server
```

Security configuration:

```bash
sudo mysql_secure_installation
```

Database setup:

```bash
# Create root password
sudo mysql -u root -p
```

Create database and user for moodle:

```bash
CREATE DATABASE moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodle'@'localhost' IDENTIFIED BY 'your-password';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
```

*PHP*

Install php:

```bash
sudo apt install php php-mysqli php-xml php-mbstring php-curl php-zip php-gd php-intl php-soap
```

Set the `max_input_vars = 5000` in the `php.ini` file:

```bash
sudo nvim /etc/php/8.2/apache2/php.ini
```

*Moodle*

Installing moodle:

Download the latest stable release from moodle.org.

Create data directory:

```bash
sudo mkdir /var/www/moodledata
```

Set permissions:
```bash
sudo chown -R www-data:www-data /var/www/html/moodle
sudo chown -R www-data:www-data /var/www/moodledata
sudo chmod -R 755 /var/www/html/moodle
sudo chmod -R 777 /var/www/moodledata
```

If everything went well you should be able to navigate to http://localhost and finish de installation from the web interface.

1. Choose a language
2. Confirm Paths
    * Web address: http://localhost
    * Moodle directory: /var/www/html/moodle
    * Data directory: /var/www/moodledata
3. Choose database driver
    * Mariadb
4. Database settings
    * Database host: localhost
    * Database name: moodle
    * Database user: moodle_user
    * Database password: password
    * Tables prefix: mdl_
    * Database port: 3306
    * Unix socket: /var/run/mysqld/mysqld.sock

You will eventually get to the point where the web interface will show errors, warnings and missing packages.  Solve those and you should be ready to go.

Finally, create a cron job for moodle:

```bash
sudo crontab -u www-data -e
```
Add the following:

* * * * * /usr/bin/php /var/www/html/moodle/admin/cli/cron.php >/dev/null

This will execute Moodle cron every minute.





