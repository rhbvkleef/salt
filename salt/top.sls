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
    