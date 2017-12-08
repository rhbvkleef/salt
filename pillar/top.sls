base:
  'G@os:debian or G@os:ubuntu':
    - match: compound
    - base.packages
    - salt

  'applications:php':
    - match: grain
    - php.packages

  # Primary hypervisor
  'titan.vankleef.me':
    - lxc.hypervisors.titan
    - libvirt.packages
    - lxc.packages
    - lxc.profiles
  
  # Testing configuration
  'dauntless.rolfvankleef.nl':
    - lxc.hypervisors.dauntless-testing
    - lxc.packages
    - lxc.profiles

  'odyssey':
    - apache-proxy.odyssey