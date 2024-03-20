class ReciptDetail {
  String? id;
  String? createdAt;
  String? productEstimation;
  CreatedBy? createdBy;
  List<RecipeItem>? recipeItem;

  ReciptDetail(
      {this.id,
      this.createdAt,
      this.productEstimation,
      this.createdBy,
      this.recipeItem});

  ReciptDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    productEstimation = json['product_estimation'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    if (json['recipe_item'] != null) {
      recipeItem = <RecipeItem>[];
      json['recipe_item'].forEach((v) {
        recipeItem!.add(RecipeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['product_estimation'] = productEstimation;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    if (recipeItem != null) {
      data['recipe_item'] = recipeItem!.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class RecipeItem {
  String? id;
  String? recipeId;
  String? name;
  String? quantity;
  String? unit;
  String? price;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;

  RecipeItem(
      {this.id,
      this.recipeId,
      this.name,
      this.quantity,
      this.unit,
      this.price,
      this.totalPrice,
      this.createdAt,
      this.updatedAt});

  RecipeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipe_id'];
    name = json['name'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['recipe_id'] = recipeId;
    data['name'] = name;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
