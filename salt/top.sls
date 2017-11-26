base:
  '*':
    - salt.minion
    - base
    - sudo
  'applications:salt-master':
    - match: grain
    - salt.master
  'applications:php':
    - match: grain
    - php
    - mariadb.install
    - sql.mariadb
  'applications:skicie-signon':
    - match: grain
    - sites.skicie-signon
  'systype:hypervisor:lxc':
    - match: grain
    - lxc
    - lxc.host
  'systype:hypervisor:libvirt':
    - match: grain
    - libvirt
