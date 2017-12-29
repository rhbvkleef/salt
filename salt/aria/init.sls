aria2:
  file.directory:
    - name: /var/lib/aria/downloads/
    - makedirs: True
    - user: root
    - group: root

  pkg.latest:
    - name: aria2

  file.managed:
    - name: /etc/systemd/system/aria2.service
    - source: salt://aria/aria.service
    - requires:
      - file: aria2
      - pkg: aria2

  service.enabled:
    - requires:
      - file: aria2

start-aria:
  service.running:
    - name: aria2
    - requires:
      - file: aria2
