import 'package:flutter/material.dart';

class ArchivistModel {
  String id;
  String name;
  String owner;
  String dns;
  String publicKey;
  int port;
  int graphqlPort;
  int boundWitnessServerPort;

  ArchivistModel(
      {@required this.dns,
      @required this.port,
      this.id,
      this.name,
      this.owner,
      this.publicKey,
      this.graphqlPort,
      this.boundWitnessServerPort});

  factory ArchivistModel.fromJson(Map json) {
    return ArchivistModel(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      dns: json['dns'],
      publicKey: json['publicKey'],
      port: json['port'],
      graphqlPort: json['graphqlPort'],
      boundWitnessServerPort: json['boundWitnessServerPort'],
    );
  }

  static ArchivistModel get defaultArchivist =>
      ArchivistModel(dns: 'alpha-peers.xyo.network', port: 11001);

  static List<ArchivistModel> fromQuery(dynamic json) {
    List sentinels = json.data['myAttachedArchivists'];
    List<ArchivistModel> models =
        sentinels.map((json) => ArchivistModel.fromJson(json)).toList();
    return models;
  }
}
