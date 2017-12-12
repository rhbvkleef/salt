{%- import_yaml "/srv/pillar/sql/robinson_private.sls" as robinson %}

postgres:
  postgresconf: |
    listen_addresses = '*'

  users:
    swipe-test:
      ensure: present
      password: {{ robinson['postgres_private']['swipe-test-password'] }}
      createdb: False
      createroles: False
      createuser: False
      inherit: True
      replication: False

  databases:
    swipe-test:
      owner: 'swipe-test'
      lc_ctype: 'en_US.UTF-8'
      lc_collate: 'en_US.UTF-8'
