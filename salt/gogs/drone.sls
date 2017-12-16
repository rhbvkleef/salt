{% set dist_def = 'http://downloads.drone.io/master/drone.deb' %}
{% set dist = salt['pillar.get']('drone:dist', dist_def) %}

docker:
  pkg.latest

drone:
  pkg.installed:
    - sources:
      - drone:
        - '{{ dist }}'
        - '{{ dist_def }}'
    - require:
      - pkg: docker
  service.running:
    - watch:
      - pkg: drone
