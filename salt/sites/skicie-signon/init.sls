write-rsa-key:
  file.managed:
    - name: /root/.ssh/id_rsa
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: skicie-signup:source:key
    - makedirs: True

remove-default-index:
  file.absent:
    - name: /var/www/html/index.html

clone-git-repo:
  git.latest:
    - name: git@gitlab.ia.utwente.nl:SkiCie/SignupWebsite.git
    - target: /var/www/html
    - user: www-data
    - require:
      - pkg: apache2
      - file: write-rsa-key
      - file: remove-default-index
