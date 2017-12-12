base:
  '*':
    - salt.minion
    - base

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