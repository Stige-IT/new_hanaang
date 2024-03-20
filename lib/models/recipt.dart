import 'package:admin_hanaang/models/material_model.dart';

class Recipt {
  String? id;
  String? createdAt;
  String? productEstimation;
  CreatedBy? createdBy;
  List<MaterialModel>? recipeItem;

  Recipt(
      {this.id,
      this.createdAt,
      this.productEstimation,
      this.createdBy,
      this.recipeItem});

  Recipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    productEstimation = json['product_estimation'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    if (json['recipe_item'] != null) {
      recipeItem = <MaterialModel>[];
      json['recipe_item'].forEach((v) {
        recipeItem!.add(MaterialModel.fromJson(v));
      });
    }
  }
}

class CreatedBy {
  String? id;
  String? name;

  CreatedBy({this.id, this.name});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
