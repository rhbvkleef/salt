phpmyadmin:
  pkg.installed:
    - name: phpmyadmin
  file.symlink:
    - name: /etc/apache2/sites-enabled/phpmyadmin.conf
    - target: /etc/phpmyadmin/apache.conf
    - require:
      - pkg: phpmyadmin
  module.wait:
    - name: apache.signal
    - signal: restart
    - watch:
      - file: /etc/apache2/sites-enabled/phpmyadmin.conf

apache2:
  pkg.installed

php:
  pkg.installed

php-mbstring:
  pkg.installed:
    - require:
      - pkg: php
