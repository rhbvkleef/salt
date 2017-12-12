lxc:
  master: salt.vankleef.me
  interface: eno1
  containers:
    # Salt master
    - hostname: venture
      ip: 10.0.3.10
      forward_ports:
        - from: 4505
          to: 4505
          proto: tcp
        - from: 4506
          to: 4506
          proto: tcp

    # SQL servers (MySQL/MariaDB and PostgreSQL)
    - hostname: robinson
      ip: 10.0.3.11

    # Git server
    - hostname: trident
      ip: 10.0.3.12
      forward_ports:
        - from: 22
          to: 2200
          proto: tcp

    # Apache proxy server
    - hostname: odyssey
      ip: 10.0.3.13
      forward_ports:
        - from: 80
          to: 80
          proto: tcp
        - from: 443
          to: 443
          proto: tcp

    # Nexus
    - hostname: excalibur
      ip: 10.0.3.14
