fix-www-perms:
  file.directory:
    - name: /var/www
    - user: www-data
    - group: www-data
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - pkg: apache2

write-rsa-key:
  file.managed:
    - name: /var/www/.ssh/id_rsa
    - user: www-data
    - group: www-data
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
    - identity: /var/www/.ssh/id_rsa
    - require:
      - pkg: apache2
      - file: write-rsa-key
      - file: remove-default-index
