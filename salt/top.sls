base:
  '*':
    - salt.minion
    - base
    - sudo

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
  
  # Salt master
  'venture':
    - salt.master
  
  # MySQL server
  'robinson':
    - mariadb.install
  
  # Git server
  'trident':
    - gogs
  
  # Apache proxy server
  'odyssey':
    - apache-proxy.certs
    - apache.vhosts.standard
    - apache.no_default_vhost
    - apache.modules
    - apache.config