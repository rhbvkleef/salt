# Install and keep base packages up to date
{% for package in pillar['libvirt']['packages'] %}
{{ package }}:
    pkg.latest
{% endfor %}
