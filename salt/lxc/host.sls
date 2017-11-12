{% for container in pillar['lxc']['containers'] %}
container-{{ container['hostname'] }}:
  lxc.present:
    - name: {{ container['hostname'] }}
    - profile: debian
    - running: true
    - options:
        arch: amd64
container-{{ container['hostname'] }}-running:
  lxc.running:
    - name: {{ container['hostname'] }}
    - require:
      - lxc: container-{{ container['hostname'] }}

container-{{ container['hostname'] }}-autostart:
  file.append:
    - name: /var/lib/lxc/{{ container['hostname'] }}/config
    - text: lxc.start.auto = 1
    - require:
      - lxc: container-{{ container['hostname'] }}

container-{{ container['hostname'] }}-bootstrapped:
  cmd.run:
    {% if container['master'] is defined %}
    - name: lxcsaltstrap -h {{ container['hostname'] }} -i {{ container['master'] }}
    {% else %}
    - name: lxcsaltstrap -h {{ container['hostname'] }}
    {% endif %}
    - unless:
      - [ -f /var/lib/lxc/{{ container['hostname'] }}/bootstrapped ]
    - onlyif:
      - touch /var/lib/lxc/{{ container['hostname'] }}/bootstrapped
    - require:
      - file: lxc_bootstrap_script
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
    - source: salt://lxc/files/default_net
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
    - source: salt://lxc/files/lxc_default.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644

lxc_bootstrap_script:
  file.managed:
    - name: /bin/lxcsaltstrap
    - source: salt://lxc/files/saltstrap.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 755