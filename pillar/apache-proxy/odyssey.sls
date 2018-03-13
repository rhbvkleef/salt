# ``apache`` formula configuration:
apache:
  pki:
    cn: titan.vankleef.me
    san:
      - git.vankleef.me
      - ci.vankleef.me
      - teamcity.vankleef.me
      - maven.vankleef.me
      - nexus.vankleef.me
      - npm.vankleef.me
      - sql.vankleef.me
      - torrent.vankleef.me
      - transmission.vankleef.me
      - aria.vankleef.me
      - aria2.vankleef.me
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

      Rewrite: |
        RewriteCond %{HTTPS} off [OR]
        RewriteCond %{HTTP:X-ForwardedProto} !https
        RewriteRule ^/(.*) https://%{HTTP_HOST}/$1 [NC,R=301,L]

    git.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: git.vankleef.me
      ServerAlias: gogs.vankleef.me

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

      Formula_Append: |
        ServerAlias git.vankleef.me
        ServerAlias sql.vankleef.me
        Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"

    ci.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: ci.vankleef.me
      ServerAlias: teamcity.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      Formula_Append: |
        ProxyPass         /app/subscriptions ws://10.0.3.12:8111/app/subscriptions
        ProxyPassReverse  /app/subscriptions ws://10.0.3.12:8111/app/subscriptions
        ProxyPass         / http://10.0.3.12:8111/
        ProxyPassReverse  / http://10.0.3.12:8111/
        Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"


    nexus.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: nexus.vankleef.me
      Formula_Append: |
        ServerAlias npm.vankleef.me
        ServerAlias maven.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.12:8081/'

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

    plex.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: plex.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.14:32400/'

      Formula_Append: Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"

    torrent.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: torrent.vankleef.me
      ServerAlias: transmission.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.14:9091/'

      Formula_Append: Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"

    aria.vankleef.me:
      enabled: True
      port: 443
      template_file: salt://apache/vhosts/proxy.tmpl

      ServerName: aria.vankleef.me
      ServerAlias: aria2.vankleef.me

      ServerAdmin: webmaster@vankleef.me

      LogLevel: warn
      CustomLog: ${APACHE_LOG_DIR}/access.log
      LogFormat: combined
      ErrorLog: ${APACHE_LOG_DIR}/error.log

      SSLCertificateFile: /etc/letsencrypt/live/titan.vankleef.me/fullchain.pem
      SSLCertificateKeyFile: /etc/letsencrypt/live/titan.vankleef.me/privkey.pem

      ProxyRoute:
        git:
          ProxyPassTarget: 'http://10.0.3.14:6800/'

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
