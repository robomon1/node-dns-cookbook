name             "node_dns"
maintainer       "Wes Morgan"
maintainer_email "cap10morgan@gmail.com"
license          "Apache 2.0"
description      "Adds node hostnames to DNS using Amazon Route 53"
version          "1.0.2"

recipe "default", "Adds the node's hostname to the desired Route 53 zone"

depends "route53"
depends "aws"
