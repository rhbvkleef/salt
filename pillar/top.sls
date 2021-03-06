base:
  'G@os:debian or G@os:ubuntu':
    - match: compound
    - base.packages
    - salt

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
  
  # Apache proxy
  'odyssey':
    - apache-proxy.odyssey

  'robinson':
    - sql.robinson

  'musashi':
    - transmission