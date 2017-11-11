{% for container in pillar['lxc']['containers'] %}
container-{{ container['hostname'] }}:
  lxc.present:
    - name: {{ container['hostname'] }}
    - profile: debian
    - running: true
    - options:
        arch: amd64
{% endfor %}

lxc_defaults:
  file.managed:
    - name: /etc/default/lxc
    - source: salt://lxc/files/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: lxc

lxc-net_defaults:
  file.managed:
    - name: /etc/default/lxc-net
    - source: salt://lxc/templates/default_net
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: lxc
  service:
    - running
    - name: lxc-net
    - require:
      - file: lxc-net_defaults
    - watch:
      - file: lxc-net_defaults

lxc_default_conf:
  file.managed:
    - name: /etc/lxc/default.conf
    - source: salt://lxc/templates/lxc_default.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
