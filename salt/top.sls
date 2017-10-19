base:
  '*':
    - salt.minion
    - base
    - sudo
  'salt-master.rolfvankleef.nl':
    - salt.master
  'applications:php':
    - match: grain
    - php
    - mariadb.install
    - sql.mariadb
  'applications:skicie-signon':
    - match: grain
    - sites.skicie-signon
    