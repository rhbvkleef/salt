# ``apache`` formula configuration:
apache:
  pki:
    cn: titan.vankleef.me
    san:
      - git.vankleef.me
      - maven.vankleef.me
      - sql.vankleef.me
    email: webmaster@rolfvankleef.nl
  
  name_virtual_hosts:
    - interface: '*'
      port: 80
    - interface: '*'
      port: 443

  sites:
    titan.vankleef.me:
      enabled: True
      port: 80
      template_file: salt://apache/vhosts/standard.tmpl

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log combined
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log
      
      Formula_Append: |
        ServerAlias git.vankleef.me
        ServerAlias maven.vankleef.me
        ServerAlias sql.vankleef.me

      Rewrite: |
        RewriteCond %{HTTPS} off [OR]
        RewriteCond %{HTTP:X-ForwardedProto} !https
        RewriteRule ^/(.*) https://%{HTTP_HOST}/$1 [NC,R=301,L]

    git.vankleef.me:
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

      Formula_Append: Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"

    maven.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: maven.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.14:8081/'

      Formula_Append: Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"

    sql.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: sql.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.11:80/'

      Formula_Append: Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"
  modules:
    enabled:
      - proxy
      - proxy_http
      - ssl
      - rewrite
      - headers

  keepalive: 'On'

  security:
    ServerTokens: Prod
