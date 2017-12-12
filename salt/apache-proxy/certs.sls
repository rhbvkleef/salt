apache_certs:
  acme.cert:
    - name: {{ pillar['apache']['pki']['cn'] }}
    - aliases:
{% for san in pillar['apache']['pki']['san'] %}
      - {{ san }}
{% endfor %}
    - email: {{ pillar['apache']['pki']['email'] }}
    - renew: 14
    - require:
      - pkg: python-certbot

python-certbot:
  pkg.latest
