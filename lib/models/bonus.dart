class Bonus {
  String? id;
  BonusType? bonusType;
  String? minimumOrder;
  String? numberOfBonus;
  String? createdAt;
  String? updatedAt;

  Bonus(
      {this.id,
        this.bonusType,
        this.minimumOrder,
        this.numberOfBonus,
        this.createdAt,
        this.updatedAt});

  Bonus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bonusType = json['bonus_type'] != null
        ? BonusType.fromJson(json['bonus_type'])
        : null;
    minimumOrder = json['minimum_order'];
    numberOfBonus = json['number_of_bonus'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class BonusType {
  String? id;
  String? name;

  BonusType({this.id, this.name});

  BonusType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
