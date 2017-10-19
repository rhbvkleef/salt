# Install and keep base packages up to date
{% for package in pillar['php']['packages'] %}
{{ package }}:
    pkg.latest
{% endfor %}

enable-rewrite-module:
  cmd.wait:
    - name: a2enmod rewrite
    - watch:
      - pkg: apache2

set-apache-config:
  file.managed:
    - name: /etc/apache2/apache2.conf
    - source: salt://php/files/apache2.conf
    - require:
      - pkg: apache2

apache2:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - cmd: enable-rewrite-module
      - file: set-apache-config