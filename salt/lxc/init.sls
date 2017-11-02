# Install and keep base packages up to date
{% for package in pillar['lxc']['packages'] %}
{{ package }}:
    pkg.latest
{% endfor %}

{% for container in pillar['lxc']['containers'] %}
container.{{ container['hostname'] }}
  lxc.present:
    - template: debian
    - running: true
    - options:
        arch: amd64
{% endfor %}
