# Loop through all lxc containers to configure them
{% for container in pillar['lxc']['containers'] %}

# Create the container
container-{{ container['hostname'] }}:
  lxc.present:
    - name: {{ container['hostname'] }}
    - profile: debian
    - running: true
    - options:
        arch: amd64

{% if container['autostart'] is defined and container['autostart'] %}

# Optionally enable the container autostart flag
container-{{ container['hostname'] }}-autostart:
  file.append:
    - name: /var/lib/lxc/{{ container['hostname'] }}/config
    - text: lxc.start.auto = 1
    - require:
      - lxc: container-{{ container['hostname'] }}
{% endif %}

{% if (not container['autobootstrap'] is defined) or container['autobootstrap'] %}

# Optionally bootstrap the container 
# Currently has a bug when the hypervisor isn't the master: cannot salt-key -a {{ container['hostname'] }}
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
      - lxc: container-{{ container['hostname'] }}
{% endif %}

{% if container['ip'] is defined %}

# Set the static IP of the container
container-{{ container['hostname'] }}-static-ip:
  file.append:
    - name: /var/lib/lxc/{{ container['hostname'] }}/config
    - text: |
        lxc.network.ipv4 = {{ container['ip'] }}/24
        lxc.network.ipv4.gateway = auto
    - require:
      - lxc: container-{{ container['hostname'] }}

{% if container['forward_ports'] is defined %}
{% for port_settings in container['forward_ports'] %}

# For all ports provided, forward them to the master interface specified
{% if port_settings['interfaces'] is defined %}
{% for interface in port_settings['interfaces']}
container-{{ container['hostname'] }}-preroute-{{ interface }}-{{ port_settings['proto'] }}/{{ port_settings['from'] }}-to-{{ port_settings['to'] }}:
  iptables.append:
    - table: nat
    - chain: PREROUTING
    {% if port_settings['proto'] is defined %}
    - proto: {{ port_settings['proto'] }}
    {% endif %}
    - dport: {{ port_settings['from'] }}
    - d: {{ salt['network.interfaces']()[interface]['inet'][0]['address'] }}
    - jump: DNAT
    - to: {{ container['ip'] }}:{{ port_settings['to'] }}
    - save: True
{% endfor %}
{% else %}
container-{{ container['hostname'] }}-preroute-{{ port_settings['proto'] }}/{{ port_settings['from'] }}-to-{{ port_settings['to'] }}:
  iptables.append:
    - table: nat
    - chain: PREROUTING
    {% if port_settings['proto'] is defined %}
    - proto: {{ port_settings['proto'] }}
    {% endif %}
    - dport: {{ port_settings['from'] }}
    - d: {{ salt['network.interfaces']()[container['interface']]['inet'][0]['address'] }}
    - jump: DNAT
    - to: {{ container['ip'] }}:{{ port_settings['to'] }}
    - save: True
{% endif %}

container-{{ container['hostname'] }}-forward-{{ port_settings['proto'] }}/{{ port_settings['from'] }}-to-{{ port_settings['to']}}:
  iptables.append:
    - chain: FORWARD
    {% if port_settings['proto'] is defined %}
    - proto: {{ port_settings['proto'] }}
    {% endif %}
    - sport: {{ port_settings['from'] }}
    - s: {{ container['ip'] }}
    - jump: ACCEPT
    - save: True

{% endfor %}
{% endif %}
{% endif %}
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