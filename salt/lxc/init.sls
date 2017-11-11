# Install and keep base packages up to date
{% for package in pillar['lxc']['packages'] %}
{{ package }}:
    pkg.latest
{% endfor %}
