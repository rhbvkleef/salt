base:
  'G@os:debian or G@os:ubuntu':
    - match: compound
    - base
    - salt
  'systype:hypervisor':
    - match: grain
    - lxc.profiles
    - lxc.packages
    - lxc.containers
  'applications:php':
    - match: grain
    - php