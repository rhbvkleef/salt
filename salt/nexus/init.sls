openjdk-8-jre:
  pkg:
    - latest

nexus-service:
  cmd.run:
    - cwd: /opt
    - name: wget https://sonatype-download.global.ssl.fastly.net/repository/repositoryManager/3/nexus-3.9.0-01-unix.tar.gz && tar -xzf nexus-3.9.0-01-unix.tar.gz && mv nexus-3.9.0-01 nexus
    - unless: test -d "/opt/nexus"
  file.managed:
    - name: /etc/systemd/system/nexus.service
    - source: salt://nexus/files/nexus.service
    - require:
      - cmd: nexus-service
      - pkg: openjdk-8-jre
  service.running:
    - name: nexus
    - enable: True
    - require:
      - file: nexus-service