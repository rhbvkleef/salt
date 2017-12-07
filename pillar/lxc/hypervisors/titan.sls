lxc:
  master: salt.vankleef.me
  interface: eno1
  containers:
    # Salt master
    - hostname: venture
      autobootstrap: False
      ip: 10.0.3.10
      forward_ports:
        - from: 4505
          to: 4505
          proto: tcp
        - from: 4506
          to: 4506
          proto: tcp

    # SQL server
    - hostname: robinson
      autobootstrap: False
      ip: 10.0.3.11
      forward_ports:
        - from: 3306
          to: 3306
          proto: tcp

    # Git server
    - hostname: trident
      autobootstrap: False
      ip: 10.0.3.12
