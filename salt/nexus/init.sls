nexus-download:
  file.managed:
    - name: /opt/nexus/latest.tgz
    - source: http://download.sonatype.com/nexus/3/latest-unix.tar.gz
    - user: root
    - group: root

nexus-extract-and-preclean:
  cmd.wait:
    - watch:
      - file: download
    - name: tar xf latest.tgz
    - cwd: /opt/nexus
  file.absent:
    - name: /opt/nexus/nexus

nexus-move-directory:
  cmd.wait:
    - watch:
      - cmd: extract
      - file: extract
    - name: mv nexus* nexus

nexus-service:
  file.managed:
    - name: /etc/systemd/system/nexus.service
    - source: salt://nexus/files/nexus.service
    - requires:
      - cmd: nexus-move-directory

  service.running:
    - name: gogs
    - enable: True
    - require:
      - file: nexus-service
    - watch:
      - cmd: nexus-move-directory
      - file: nexus-service