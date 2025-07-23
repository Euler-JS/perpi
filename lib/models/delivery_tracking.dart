// lib/models/delivery_tracking.dart
class DeliveryTracking {
  String orderId;
  String driverName;
  String driverPhone;
  String driverPhoto;
  String estimatedTime;
  String deliveryAddress;
  DeliveryStatus status;
  List<TrackingStep> trackingSteps;
  DriverLocation driverLocation;
  CustomerLocation customerLocation;
  double totalAmount;
  String paymentMethod;
  List<OrderItem> items;

  DeliveryTracking({
    required this.orderId,
    required this.driverName,
    required this.driverPhone,
    required this.driverPhoto,
    required this.estimatedTime,
    required this.deliveryAddress,
    required this.status,
    required this.trackingSteps,
    required this.driverLocation,
    required this.customerLocation,
    required this.totalAmount,
    required this.paymentMethod,
    required this.items,
  });
}

class DriverLocation {
  double latitude;
  double longitude;
  String address;
  bool isMoving;

  DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.isMoving = false,
  });
}

class CustomerLocation {
  double latitude;
  double longitude;
  String address;

  CustomerLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class TrackingStep {
  String title;
  String description;
  DateTime timestamp;
  bool isCompleted;
  bool isCurrent;

  TrackingStep({
    required this.title,
    required this.description,
    required this.timestamp,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class OrderItem {
  String name;
  int quantity;
  double price;
  String imageUrl;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

enum DeliveryStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  delivered,
  cancelled
}

// Dados de exemplo para demonstração
DeliveryTracking mockDeliveryTracking = DeliveryTracking(
  orderId: "#NEJ20089934122231",
  driverName: "João Silva",
  driverPhone: "+258 84 123 4567",
  driverPhoto: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face",
  estimatedTime: "7 mins",
  deliveryAddress: "Avenida Julius Nyerere, 1234, Maputo",
  status: DeliveryStatus.shipped,
  totalAmount: 845.50,
  paymentMethod: "MPesa",
  driverLocation: DriverLocation(
    latitude: -25.9692,
    longitude: 32.5732,
    address: "Avenida 24 de Julho",
    isMoving: true,
  ),
  customerLocation: CustomerLocation(
    latitude: -25.9653,
    longitude: 32.5892,
    address: "Avenida Julius Nyerere, 1234",
  ),
  trackingSteps: [
    TrackingStep(
      title: "Pedido Confirmado",
      description: "O seu pedido foi confirmado",
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isCompleted: true,
    ),
    TrackingStep(
      title: "Preparando",
      description: "O pedido está sendo preparado",
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isCompleted: true,
    ),
    TrackingStep(
      title: "A Caminho",
      description: "O entregador saiu para entrega",
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      isCompleted: true,
      isCurrent: true,
    ),
    TrackingStep(
      title: "Entregue",
      description: "Pedido entregue com sucesso",
      timestamp: DateTime.now().add(const Duration(minutes: 7)),
      isCompleted: false,
    ),
  ],
  items: [
    OrderItem(
      name: "Maçãs Vermelhas",
      quantity: 2,
      price: 300.00,
      imageUrl: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=100&h=100&fit=crop&crop=center",
    ),
    OrderItem(
      name: "Leite Integral",
      quantity: 1,
      price: 85.00,
      imageUrl: "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=100&h=100&fit=crop&crop=center",
    ),
    OrderItem(
      name: "Pão Francês",
      quantity: 6,
      price: 15.00,
      imageUrl: "https://images.unsplash.com/photo-1585478259715-876acc5be8eb?w=100&h=100&fit=crop&crop=center",
    ),
  ],
);