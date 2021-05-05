Name: {{.serviceName}}.rpc
ListenOn: 127.0.0.1:8080
HttpStatus: true
HttpPort: ":6999"
Etcd:
  Hosts:
  - 127.0.0.1:2379
  Key: {{.serviceName}}.rpc
