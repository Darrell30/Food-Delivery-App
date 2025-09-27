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

final List<Order> initialOrdersList = [
  Order(
    id: 'ORD001',
    status: OrderStatus.completed,
    items: ['Pizza', 'Cola'],
    totalPrice: 150000,
  ),
  Order(
    id: 'ORD002',
    status: OrderStatus.onDelivery,
    items: ['Burger'],
    totalPrice: 75000,
  ),
  Order(
    id: 'ORD003',
    status: OrderStatus.pending, 
    items: ['Fried Chicken', 'Rice'],
    totalPrice: 85000,
  ),
  Order(
    id: 'ORD004',
    status: OrderStatus.completed,
    items: ['Noodles', 'Ice Tea'],
    totalPrice: 60000,
  ),
  Order(
    id: 'ORD005',
    status: OrderStatus.pending,
    items: ['Milk Tea', 'Waffle'],
    totalPrice: 35000,
  ),
];