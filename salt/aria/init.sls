aria2:
  file.directory:
    - name: /var/lib/aria/downloads/
    - makedirs: True
    - user: root
    - group: root

  pkg.latest

  file.managed:
    - name: /etc/systemd/system/aria.service
    - source: salt://aria/aria.service
    - requires:
      - file: aria2
      - pkg: aria2

  service.enabled:
    - name: aria
    - requires:
      - file: aria2

start-aria:
  service.running:
    - name: aria
    - requires:
      - file: aria2
