base:
  '*':
    - salt.minion
    - base
  'salt-master.rolfvankleef.nl':
    - salt.master
    