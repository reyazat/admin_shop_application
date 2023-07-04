class ProductsModel {
    String orderProductId;
    String productId;
    String name;
    String model;
    List<Map<String,dynamic>> option;
    String quantity;
    String price;
    String total;
    String image;
    List<ProductCategory> productCategories;
    dynamic special;
    String status;
    String points;

    ProductsModel({
        this.orderProductId,
        this.productId,
        this.name,
        this.model,
        this.option,
        this.quantity,
        this.price,
        this.total,
        this.image,
        this.productCategories,
        this.special,
        this.status,
        this.points,
    });

    factory ProductsModel.fromJson(Map<String, dynamic> json) {
        return ProductsModel(
            orderProductId: json['order_product_id'].toString() ?? '',
            productId: json['product_id'].toString() ?? '',
            name: json['name'].toString() ?? '',
            model: json['model'].toString() ?? '',
            option: json['option'] != null ? List<Map<String,dynamic>>.from(json['option'].map((x) => x)) : [],
            quantity: json['quantity'].toString() ?? '',
            price: json['price'].toString() ?? '',
            total: json['total'].toString() ?? '',
            image: json['image'] ?? '',
            productCategories: json['product_categories'] != null ? (json['product_categories'] as List).map((i) => ProductCategory.fromJson(i)).toList() : [],
            special: json['special'] ?? '',
            status: json['status'] ?? '',
            points: json['points'] ?? '',
        );
    }
}

class ProductCategory {
    String categoryId;
    String name;

    ProductCategory({this.categoryId, this.name});

    factory ProductCategory.fromJson(Map<String, dynamic> json) {
        return ProductCategory(
            categoryId: json['category_id'] ?? '',
            name: json['name'] ?? '',
        );
    }
}