lxc.container_profile:
  debian:
    template: debian
    backing: lvm
    vgname: vg1
    lvname: lxclv
    size: 10G