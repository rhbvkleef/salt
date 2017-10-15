base:
  '*':
    - base
    - salt
  'systype:hypervisor':
    - match: grain
    - lxc.profiles
    - lxc.packages