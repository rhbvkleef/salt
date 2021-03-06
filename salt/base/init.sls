
# Create management user
rolf:
  user.present:
    - name: rolf
    - uid: 1000
    - gid_from_name: True
    - password: {{ salt['pillar.get']('user:root:passwdhash') }}
    - shell: /bin/zsh
    - home: /home/rolf
    - createhome: True
    - require:
      - group: sudoers
      - pkg: zsh
    - groups:
      - sudoers

sudoers:
  group.present:
    - name: sudoers

# Install and keep base packages up to date
{% for package in pillar['base']['packages'] %}
{{ package }}:
    pkg.latest
{% endfor %}
    
# Salt repository for latest versions of salt master and minions.
salt-repo:
  cmd.wait:
    - name: wget -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
    - watch:
      - file: salt-repo
  file.managed:
    - name: /etc/apt/sources.list.d/salt.list
    - source: salt://base/files/salt.list

# Force IPv4 usage for APT because IPv6 is buggy
/etc/apt/apt.conf.d/99force-ipv4:
  file.managed:
    - source: salt://base/files/apt_force_ipv4

# Start ssh server
sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: sshd
    - enable: True
    - require:
      - pkg: sshd

sudo:
  pkg.latest:
    - name: sudo
  file.managed:
    - name: /etc/sudoers.d/sudoers_group
    - source: salt://base/files/sudoers_group
    - makedirs: True
    - mode: 440
