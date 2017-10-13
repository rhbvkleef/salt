salt:
  minion:
    master: localhost
    mine_interval: 60
  master:
    ipv6: True
    file_roots:
      base:
        - /srv/salt
    file_ignore_regex:
      - '/\.git($|/)'
    fileserver_backend:
      - git
      - roots
    gitfs_remotes:
      - git://github.com:rhbvkleef/salt.git:
        - root: salt
      - git://github.com:saltstack-formulas/salt-formula.git
    pillar_roots:
      base:
        - /srv/pillar
    gitfs_provider: gitpython
    git_pillar_provider: gitpython
    git_pillar_root: pillar
    ext_pillar: 
      - git: 
        - master git://github.com:rhbvkleef/salt.git:
          - env: base
    state_verbose: False
    state_output: mixed
    output: nested

mine_functions:
  network.interfaces: []
  network.ip_addrs: []
  grains.items: []
  ssh_host_keys:
    mine_function: ssh.host_keys
    private: False
