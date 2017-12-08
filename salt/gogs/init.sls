gogs:
  user.present:
    - name: git
    - fullname: Git
    - home: /home/git
    - createhome: True
  cmd:
    - cwd: /opt
    - names:
      - wget -O gogs.zip https://dl.gogs.io/0.11.4/linux_amd64.zip && mv -T gogs gogs_`date +"%Y%m%d"` && unzip gogs.zip -d /opt && setfacl -Rm u:git:r-x gogs
    - run
    - unless: test -d "/opt/gogs/public"
    - require:
      - user: gogs

  file.managed:
    - name: /etc/systemd/system/gogs.service
    - source: salt://gogs/gogs.service
    - requires:
      - cmd: gogs

  service.running:
    - name: gogs
    - enable: True
    - require:
      - file: gogs
      - file: gogs-config
    - watch:
      - cmd: gogs
      - file: gogs-config

gogs-config:
  file.managed:
    - name: /opt/gogs/custom/conf/app.ini
    - source: salt://gogs/gogs.config
    - user: git
    - group: git
    - makedirs: True
    - template: jinja
    - requires: 
      - cmd: gogs
      - user: gogs
