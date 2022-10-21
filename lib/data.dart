import 'dart:convert';

List<String> charNameFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String charNameToJson(List<String> data) =>
    json.encode(List<String>.from(data.map((x) => x)));

Character characterFromJson(String str) => Character.fromJson(json.decode(str));

String characterToJson(Character data) => json.encode(data.toJson());

class Character {
  Character({
    required this.name,
    required this.vision,
    required this.weapon,
    required this.nation,
    required this.affiliation,
    required this.constellation,
    required this.description,
  });

  String name;
  String vision;
  String weapon;
  String nation;
  String affiliation;
  String constellation;
  String description;

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        name: json["name"],
        vision: json["vision"],
        weapon: json["weapon"],
        nation: json["nation"],
        affiliation: json["affiliation"],
        constellation: json["constellation"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "vision": vision,
        "weapon": weapon,
        "nation": nation,
        "affiliation": affiliation,
        "constellation": constellation,
        "description": description,
      };
}
