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
    example.net:
      template_file: salt://apache/vhosts/minimal.tmpl

    git.vankleef.me: # must be unique; used as an ID declaration in Salt.
      enabled: True
      template_file: salt://apache/vhosts/standard.tmpl # or minimal.tmpl or redirect.tmpl or proxy.tmpl

      ServerName: git.vankleef.me # uses the unique ID above unless specified
      ServerAlias: www.git.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      ErrorLog: /path/to/logs/example.com-error.log # E.g.: /var/log/apache2/example.com-error.log
      CustomLog: /path/to/logs/example.com-access.log # E.g.: /var/log/apache2/example.com-access.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      RedirectSource: '/'
      RedirectTarget: 'http//10.0.3.12:3000/'
      DocumentRoot: /var/www

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
