class Server {
  Server(
      this.id,
      this.credentialId,
      this.name,
      this.size,
      this.region,
      this.phpVersion,
      this.phpCliVersion,
      this.opcacheStatus,
      this.databaseType,
      this.publicIp,
      this.privateIp);

  int id;
  int? credentialId;
  String name;
  String? size;
  String? region;
  String? phpVersion;
  String? phpCliVersion;
  String? opcacheStatus;
  String? databaseType;
  String publicIp;
  String privateIp;

  static Server fromJson(json) {
    return Server(
        json['id'],
        json['credential_id'],
        json['name'],
        json['size'],
        json['region'],
        json['php_version'],
        json['php_cli_version'],
        json['opcache_status'],
        json['database_type'],
        json['ip_address'],
        json['private_ip_address']);
  }
}
