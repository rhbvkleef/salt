# ``apache`` formula configuration:
apache:
  pki:
    cn: titan.vankleef.me
    san:
      - git.vankleef.me
    email: webmaster@rolfvankleef.nl
  
  name_virtual_hosts:
    - interface: '*'
      port: 80
    - interface: '*'
      port: 443

  sites:
    git.vankleef.me: # must be unique; used as an ID declaration in Salt.
      enabled: True
      template_file: salt://apache/vhosts/proxy.tmpl # or minimal.tmpl or redirect.tmpl or proxy.tmpl

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRequests: 'Off'
      ProxyPreserveHost: 'On'

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.12:3000/'

  modules:
    enabled:
      - proxy
      - proxy_http
      - ssl
    disabled:
      - rewrite

  keepalive: 'On'

  security:
    ServerTokens: Prod
