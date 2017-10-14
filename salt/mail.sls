root_mail_forward:
  alias.present:
    - name: root
    - target: root@vankleef.me

nullmailer:
  pkg.latest:
    - name: nullmailer

nullmailer-adminaddr:
  file.managed:
    - name: /etc/nullmailer/adminaddr
    - contents: root@vankleef.me
    - makedirs: True

nullmailer-remotes:
  file.managed:
    - name: /etc/nullmailer/remotes
    - contents: mail.vankleef.me
    - makedirs: True

nullmailer-defaultdomain:
  file.managed:
    - name: /etc/nullmailer/defaultdomain
    - contents: vankleef.me
    - makedirs: True
