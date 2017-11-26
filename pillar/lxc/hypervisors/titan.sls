lxc:
  containers:
    - venture:
      hostname: venture
      autostart: True
      master: salt.vankleef.me
      autobootstrap: False
      ip: 10.0.3.10
      forward_interface: eno1
      forward_ports:
        - 4505:
          proto: tcp
        - 4506:
          proto: tcp
