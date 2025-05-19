locals {
  this_sg_id = var.enabled && var.create_security_group ? aws_security_group.this[0].id : var.name
}

locals {
  expanded_ingress_rules = merge(
    {
      for key in var.ingress_rule_keys : key => merge(
        local.predefined_rules[key],
        {
          rule_key    = key
          cidr_blocks = var.default_cidr_blocks
        }
      )
    },
    {
      for idx, rule in var.ingress_rules :
      "custom-ingress-${idx}" => rule
    }
  )

  expanded_egress_rules = merge(
    {
      for key in var.egress_rule_keys : key => merge(
        local.predefined_rules[key],
        {
          rule_key    = key
          cidr_blocks = var.default_cidr_blocks
        }
      )
    },
    {
      for idx, rule in var.egress_rules :
      "custom-egress-${idx}" => rule
    }
  )
}


locals {
   predefined_rules = {
     # All-Allow Rule (IPv4)
    all-allow = {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "Allow all traffic"
    }

    # OS and Services
    ftp-data = {
      from_port   = 20
      to_port     = 20
      protocol    = "tcp"
      description = "FTP (Data)"
    }
    ftp = {
      from_port   = 21
      to_port     = 21
      protocol    = "tcp"
      description = "FTP (Control)"
    }
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH / SFTP"
    }
    telnet = {
      from_port   = 23
      to_port     = 23
      protocol    = "tcp"
      description = "Telnet"
    }
    smtp = {
      from_port   = 25
      to_port     = 25
      protocol    = "tcp"
      description = "SMTP"
    }
    dns = {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      description = "DNS"
    }
    dhcp-server = {
      from_port   = 67
      to_port     = 67
      protocol    = "udp"
      description = "DHCP Server"
    }
    dhcp-client = {
      from_port   = 68
      to_port     = 68
      protocol    = "udp"
      description = "DHCP Client"
    }
    tftp = {
      from_port   = 69
      to_port     = 69
      protocol    = "udp"
      description = "TFTP"
    }
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
    }
    pop3 = {
      from_port   = 110
      to_port     = 110
      protocol    = "tcp"
      description = "POP3"
    }
    ntp = {
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      description = "NTP"
    }
    netbios-name = {
      from_port   = 137
      to_port     = 137
      protocol    = "udp"
      description = "NetBIOS Name"
    }
    netbios-dgm = {
      from_port   = 138
      to_port     = 138
      protocol    = "udp"
      description = "NetBIOS Datagram"
    }
    netbios-ssn = {
      from_port   = 139
      to_port     = 139
      protocol    = "tcp"
      description = "NetBIOS Session"
    }
    imap = {
      from_port   = 143
      to_port     = 143
      protocol    = "tcp"
      description = "IMAP"
    }
    snmp = {
      from_port   = 161
      to_port     = 161
      protocol    = "udp"
      description = "SNMP"
    }
    snmp-trap = {
      from_port   = 162
      to_port     = 162
      protocol    = "udp"
      description = "SNMP Trap"
    }
    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
    }
    smb = {
      from_port   = 445
      to_port     = 445
      protocol    = "tcp"
      description = "SMB / CIFS"
    }

    # Developer Tools & Local Dev
    react-dev = {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "React/Node.js Dev Server"
    }
    alt-react-dev = {
      from_port   = 3001
      to_port     = 3001
      protocol    = "tcp"
      description = "Alt React/Dev server"
    }
    graphql = {
      from_port   = 4000
      to_port     = 4000
      protocol    = "tcp"
      description = "GraphQL Playground"
    }
    flask = {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      description = "Flask, Python Apps"
    }
    alt-flask = {
      from_port   = 5001
      to_port     = 5001
      protocol    = "tcp"
      description = "Alt Flask instance"
    }
    vite = {
      from_port   = 5173
      to_port     = 5173
      protocol    = "tcp"
      description = "Vite Dev Server"
    }
    storybook = {
      from_port   = 6006
      to_port     = 6006
      protocol    = "tcp"
      description = "Storybook"
    }
    dev-api = {
      from_port   = 7000
      to_port     = 7000
      protocol    = "tcp"
      description = "Custom Dev APIs"
    }
    springboot = {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Alternate HTTP / SpringBoot"
    }
    react-native = {
      from_port   = 8081
      to_port     = 8081
      protocol    = "tcp"
      description = "React Native"
    }
    jupyter = {
      from_port   = 8888
      to_port     = 8888
      protocol    = "tcp"
      description = "Jupyter Notebooks"
    }
    webpack = {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "Webpack Dev, SonarQube"
    }
    scdf = {
      from_port   = 9393
      to_port     = 9393
      protocol    = "tcp"
      description = "Spring Cloud Data Flow"
    }
    https-alt = {
      from_port   = 9443
      to_port     = 9443
      protocol    = "tcp"
      description = "HTTPS Dev Alt"
    }
    
    # Databases
    mssql = {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      description = "Microsoft SQL Server"
    }
    oracle = {
      from_port   = 1521
      to_port     = 1521
      protocol    = "tcp"
      description = "Oracle DB"
    }
    mysql = {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL"
    }
    postgres = {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL"
    }
    redis = {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      description = "Redis"
    }
    redis-tls = {
      from_port   = 6380
      to_port     = 6380
      protocol    = "tcp"
      description = "Redis (TLS)"
    }
    mongo = {
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      description = "MongoDB"
    }
    mongo-secondary = {
      from_port   = 27018
      to_port     = 27018
      protocol    = "tcp"
      description = "MongoDB Secondary"
    }
    elasticsearch-http = {
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      description = "Elasticsearch (HTTP)"
    }
    elasticsearch-transport = {
      from_port   = 9300
      to_port     = 9300
      protocol    = "tcp"
      description = "Elasticsearch (Transport)"
    }
    couchdb = {
      from_port   = 5984
      to_port     = 5984
      protocol    = "tcp"
      description = "CouchDB"
    }
    arangodb = {
      from_port   = 8529
      to_port     = 8529
      protocol    = "tcp"
      description = "ArangoDB"
    }

    # Messaging & Streaming
    nats = {
      from_port   = 4222
      to_port     = 4222
      protocol    = "tcp"
      description = "NATS"
    }
    rabbitmq-amqp = {
      from_port   = 5672
      to_port     = 5672
      protocol    = "tcp"
      description = "RabbitMQ (AMQP)"
    }
    rabbitmq-ui = {
      from_port   = 15672
      to_port     = 15672
      protocol    = "tcp"
      description = "RabbitMQ UI"
    }
    mqtt = {
      from_port   = 1883
      to_port     = 1883
      protocol    = "tcp"
      description = "MQTT"
    }
    kafka = {
      from_port   = 9092
      to_port     = 9092
      protocol    = "tcp"
      description = "Kafka"
    }
    zookeeper = {
      from_port   = 2181
      to_port     = 2181
      protocol    = "tcp"
      description = "ZooKeeper"
    }
    mysql-x = {
      from_port   = 33060
      to_port     = 33060
      protocol    = "tcp"
      description = "MySQL X Protocol"
    }

    # Security, Identity, & Auth
    ldaps = {
      from_port   = 636
      to_port     = 636
      protocol    = "tcp"
      description = "LDAPS"
    }
    ipsec-ike = {
      from_port   = 500
      to_port     = 500
      protocol    = "udp"
      description = "IPsec IKE"
    }
    ipsec-natt = {
      from_port   = 4500
      to_port     = 4500
      protocol    = "udp"
      description = "IPsec NAT-T"
    }
    ldap = {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = "LDAP"
    }
    radius-auth = {
      from_port   = 1645
      to_port     = 1645
      protocol    = "udp"
      description = "RADIUS (Auth)"
    }
    radius-alt = {
      from_port   = 1812
      to_port     = 1812
      protocol    = "udp"
      description = "RADIUS (Alt)"
    }
    radius-accounting = {
      from_port   = 1813
      to_port     = 1813
      protocol    = "udp"
      description = "RADIUS Accounting"
    }
  }
}