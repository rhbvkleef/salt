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
      forward_ports:
        - from: 5432
          to: 5432
          proto: tcp

    # Git and Nexus server
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
    
    # Media server
    - hostname: musashi
      ip: 10.0.3.14
      forward_ports:
        - from: 32400
          to: 32400
          proto: tcp
