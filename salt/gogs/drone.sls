{% set dist_def = 'http://downloads.drone.io/master/drone.deb' %}
{% set dist = salt['pillar.get']('drone:dist', dist_def) %}

docker:
  pkg.latest

drone:
  pkg.installed:
    - sources:
      - drone: '{{ dist }}'
    - require:
      - pkg: docker
  file.managed:
    - name: /etc/drone/drone.toml
    - source: salt://salt/gogs/drone.toml
    - template: jinja
    - requires:
      - pkg: drone
  service.running:
    - watch:
      - file: drone
