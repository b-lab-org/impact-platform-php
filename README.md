# Impact Platform: PHP
[Docker](https://www.docker.com/) container for [PHP](http://www.php.net/).

## Overview
Use with the [data container](https://github.com/b-lab-org/impact-platform-data) and [memcached container](https://github.com/b-lab-org/impact-platform-memcached).

## Docker-Compose Usage
```
php:
    image: impactbot/impact-platform-php
    entrypoint: php <your php command>
    volumes_from:
        - data
```
