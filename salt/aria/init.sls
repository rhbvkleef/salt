aria2:
  pkg.latest:
    - name: aria2

  file.managed:
    - name: /etc/systemd/system/aria2.service
    - source: salt://aria/aria.service
    - template: jinja
    - requires:
      - file: aria2
      - pkg: aria2

  service.enabled:
    - requires:
      - file: aria2

aria2-downloads-folder-present:
  file.directory:
    - name: /var/lib/aria/downloads/
    - makedirs: True
    - user: root
    - group: root

start-aria2-service:
  service.running:
    - name: aria2
    - requires:
      - file: aria2
      - file: aria2-downloads-folder-present
