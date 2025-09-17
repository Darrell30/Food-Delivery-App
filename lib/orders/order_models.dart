enum OrderStatus { all, pending, onDelivery, completed }

class Order {
  final String id;
  final OrderStatus status;
  final List<String> items;
  final double totalPrice;

  Order({
    required this.id,
    required this.status,
    required this.items,
    required this.totalPrice,
  });
}