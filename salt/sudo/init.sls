sudo:
  pkg.latest:
    - name: sudo
  file.managed:
    - name: /etc/sudoers.d/sudoers_group
    - source: salt://sudo/files/sudoers_group
    - makedirs: True
    - mode: 440
