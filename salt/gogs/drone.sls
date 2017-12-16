{% set dist_def = 'http://downloads.drone.io/master/drone.deb' %}
{% set dist = salt['pillar.get']('drone:dist', dist_def) %}

docker.io:
  pkg.latest

drone:
  pkg.installed:
    - sources:
      - drone:
        - '{{ dist }}'
        - '{{ dist_def }}'
    - require:
      - pkg: docker.io
  service.running:
    - watch:
      - pkg: drone
