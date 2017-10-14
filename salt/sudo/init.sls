sudo:
  pkg.latest:
    - name: sudo
  file.managed:
    - name: /etc/sudoers.d/rolf
    - source: salt://sudo/files/rolf
    - makedirs: True
    - mode: 440
