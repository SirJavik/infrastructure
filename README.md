# infrastructure
Git Repository for OpenTofu-Code for JavikWeb-Project using [Hetzner Cloud](https://www.hetzner.com/cloud/).\
Written by [Benjamin Schneider](mailto:gitlab@sirjavik.de)

## Modules
### Own
* [HCloud VServer Module](https://gitlab.com/Javik/terraform-hcloud-vserver)\
Module for creation of servers in the Hetzner Cloud. Module takes care of rdns, dns (via cloudflare) and other stuff
* [HCloud Terraform Module](https://gitlab.com/Javik/terraform-hcloud-loadbalancer)\
Module for creation of loadbalancers in the Hetzner Cloud. Creates also required dns entries for loadbalancer.
* [HCloud Network Module](https://gitlab.com/Javik/terraform-hcloud-network)\
Creates and manages required (sub)networks for hcloud vservers.
* [Cloudflare DNS Module](https://gitlab.com/Javik/terraform-cloudflare-dns)\
Manages dns entries for mail and other domain-related stuff.
* [JavikWeb Global Module](https://gitlab.com/Javik/terraform-javikweb-globals)\
Contains variables used in other modules.
### Third-Party
* Currently none

## Providers
### Own
* Currently none
### Third-Party
* [hetznercloud/hcloud](https://registry.terraform.io/namespaces/hetznercloud)
* [cloudflare/cloudflare](https://registry.terraform.io/providers/cloudflare/cloudflare/latest)
* [vancluever/acme](https://registry.terraform.io/providers/vancluever/acme/latest)

## Current servers
### Active
* lb1-fsn1.infra.sirjavik.de
* mail1-fsn1.infra.sirjavik.de

### Under construction
* webstorage1-fsn1.infra.sirjavik.de
* webstorage2-nbg1.infra.sirjavik.de
* webstorage3-fsn1.infra.sirjavik.de
* icinga1-fsn1.infra.sirjavik.de
* icinga2-nbg1.infra.sirjavik.de
* mailng1-fsn1.infra.sirjavik.de
* mailng2-nbg1.infra.sirjavik.de

## HA Concept
* Icinga\
Using floating IP and keepalived. Only one server is active at a time.
* Webstorage\
Loadbalancer and GlusterFS for file sharing. MariaDB Galera Cluster.
* Mailng
Using floating IP and keepalived. Only one server is active at a time.

## Other Repositories
* https://github.com/SirJavik/infrastructure (Mirror)
* https://gitlab.com/Javik/ansible
