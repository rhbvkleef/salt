# Install and keep base packages up to date
{% for package in pillar['php']['packages'] %}
{{ package }}:
    pkg.latest
{% endfor %}