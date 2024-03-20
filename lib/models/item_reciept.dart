import 'package:admin_hanaang/models/material_model.dart';

class ItemRecipt {
  String? id;
  Recipe? recipe;

  ItemRecipt({this.id, this.recipe});

  ItemRecipt.fromJson(Map<String, dynamic> json) {
    recipe = json['recipe'] != null ? Recipe.fromJson(json['recipe']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipe != null) {
      data['recipe'] = recipe!.toJson();
    }
    return data;
  }
}

class Recipe {
  List<MaterialModel>? recipeItem;
  int? productEstimation;

  Recipe({this.recipeItem, this.productEstimation});

  Recipe.fromJson(Map<String, dynamic> json) {
    if (json['recipe_item'] != null) {
      recipeItem = <MaterialModel>[];
      json['recipe_item'].forEach((v) {
        recipeItem!.add(MaterialModel.fromJson(v));
      });
    }
    productEstimation = json['product_estimation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipeItem != null) {
      data['recipe_item'] = recipeItem!.map((v) => v.toJson()).toList();
    }
    data['product_estimation'] = productEstimation;
    return data;
  }
}

class ItemMaterial {
  String? id;
  int? quantity;
  MaterialModel? material;

  ItemMaterial({this.id, this.quantity, this.material});
}
