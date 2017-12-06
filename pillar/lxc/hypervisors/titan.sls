lxc:
  containers:
    - hostname: venture
      autostart: True
      master: salt.vankleef.me
      autobootstrap: False
      ip: 10.0.3.10
      interface: eno1
      forward_ports:
        - from: 4505
          to: 4505
          proto: tcp
        - from: 4506
          to: 4506
          proto: tcp
