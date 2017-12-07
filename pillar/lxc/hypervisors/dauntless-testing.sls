lxc:
  containers:
    - hostname: lxc-test
      autostart: True
      master: salt.vankleef.me
      autobootstrap: False
      ip: 10.0.3.10
      interface: enp0s3
      forward_ports:
        - from: 80
          to: 80
          proto: tcp
        - from: 443
          to: 443
          proto: tcp