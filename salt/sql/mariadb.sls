include:
  - mariadb.install

mariadb-config:
  file.managed:
    - name: /etc/mysql/conf.d/mariadb_config.cnf
    - source: salt://sql/mariadb_config.cnf
    - require:
      - pkg: install-mariadb
