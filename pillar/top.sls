base:
  'G@os:debian or G@os:ubuntu':
    - match: compound
    - base.packages
    - salt
  'systype:hypervisor:lxc':
    - match: grain
    - lxc.profiles
    - lxc.packages
  'systype:hypervisor:libvirt':
    - match: grain
    - libvirt.packages
  'applications:php':
    - match: grain
    - php.packages
  'titan.vankleef.me':
    - lxc.hypervisors.titan