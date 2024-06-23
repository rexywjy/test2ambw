class CheckoutItem {
  final int cartId;
  final int productId;
  final String productName;
  final int productQty;
  final int productPrice;
  final int productSubtotal;
  final String productImg;

  CheckoutItem({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productQty,
    required this.productPrice,
    required this.productSubtotal,
    required this.productImg,
  });

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'productId': productId,
      'productName': productName,
      'productQty': productQty,
      'productPrice': productPrice,
      'productSubtotal': productSubtotal,
      'productImg': productImg
    };
  }
  factory CheckoutItem.fromJson(Map<String, dynamic> json) {
    return CheckoutItem(
      cartId: json['cardId'],
      productId: json['productId'],
      productName: json['productName'],
      productQty: json['productQty'],
      productPrice: json['productPrice'],
      productSubtotal: json['productSubtotal'],
      productImg: json['productImg']
    );
  }
}
