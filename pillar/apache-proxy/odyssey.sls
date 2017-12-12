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
    git.vankleef.me:
      enabled: True
      port: 80
      template_file: salt://apache/vhosts/standard.tmpl

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log combined
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log
      
      Rewrite: |
        RewriteCond %{HTTPS} off [OR]
        RewriteCond %{HTTP:X-ForwardedProto} !https
        RewriteRule ^/(.*) https://%{HTTP_HOST}/$1 [NC,R=301,L]

    git.vankleef.me-ssl:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: git.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

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
