import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingService {
  static final TrackingService _instance = TrackingService._internal();
  factory TrackingService() => _instance;
  TrackingService._internal();

  Timer? _locationTimer;
  StreamController<LatLng> _locationController = StreamController<LatLng>.broadcast();
  StreamController<OrderStatus> _statusController = StreamController<OrderStatus>.broadcast();

  Stream<LatLng> get locationStream => _locationController.stream;
  Stream<OrderStatus> get statusStream => _statusController.stream;

  // Coordenadas de exemplo para Maputo
  final LatLng _restaurantLocation = LatLng(-25.9662, 32.5702);
  final LatLng _deliveryLocation = LatLng(-25.9722, 32.5762);
  LatLng _currentDriverLocation = LatLng(-25.9662, 32.5702);

  OrderStatus _currentStatus = OrderStatus.preparing;
  int _simulationStep = 0;
  final List<LatLng> _routePoints = [];

  void startTracking() {
    _generateRoute();
    _startLocationSimulation();
  }

  void _generateRoute() {
    // Simula uma rota com pontos intermediários
    _routePoints.clear();
    _routePoints.add(_restaurantLocation);
    
    // Adiciona alguns pontos intermediários para simular uma rota realista
    _routePoints.add(LatLng(-25.9672, 32.5712));
    _routePoints.add(LatLng(-25.9682, 32.5732));
    _routePoints.add(LatLng(-25.9692, 32.5742));
    _routePoints.add(LatLng(-25.9702, 32.5752));
    _routePoints.add(_deliveryLocation);
  }

  void _startLocationSimulation() {
    _locationTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _updateDriverLocation();
    });
  }

  void _updateDriverLocation() {
    if (_simulationStep < _routePoints.length - 1) {
      // Simula movimento gradual entre pontos
      double progress = (_simulationStep % 10) / 10.0;
      LatLng currentPoint = _routePoints[_simulationStep ~/ 10];
      LatLng nextPoint = _routePoints[(_simulationStep ~/ 10) + 1];
      
      double lat = currentPoint.latitude + 
          (nextPoint.latitude - currentPoint.latitude) * progress;
      double lng = currentPoint.longitude + 
          (nextPoint.longitude - currentPoint.longitude) * progress;
      
      _currentDriverLocation = LatLng(lat, lng);
      _locationController.add(_currentDriverLocation);
      
      // Atualiza status baseado na posição
      _updateOrderStatus();
      
      _simulationStep++;
      
      if (_simulationStep >= (_routePoints.length - 1) * 10) {
        // Chegou ao destino
        _currentStatus = OrderStatus.delivered;
        _statusController.add(_currentStatus);
        stopTracking();
      }
    }
  }

  void _updateOrderStatus() {
    double totalSteps = (_routePoints.length - 1) * 10;
    double progress = _simulationStep / totalSteps;
    
    OrderStatus newStatus;
    if (progress < 0.1) {
      newStatus = OrderStatus.preparing;
    } else if (progress < 0.3) {
      newStatus = OrderStatus.ready;
    } else if (progress < 0.5) {
      newStatus = OrderStatus.pickedUp;
    } else if (progress < 0.9) {
      newStatus = OrderStatus.onTheWay;
    } else {
      newStatus = OrderStatus.nearDelivery;
    }
    
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
    }
  }

  LatLng getCurrentDriverLocation() => _currentDriverLocation;
  OrderStatus getCurrentStatus() => _currentStatus;

  double getEstimatedTimeMinutes() {
    double totalSteps = (_routePoints.length - 1) * 10;
    double remainingProgress = 1 - (_simulationStep / totalSteps);
    return remainingProgress * 25; // 25 minutos máximo estimado
  }

  String getStatusMessage() {
    switch (_currentStatus) {
      case OrderStatus.preparing:
        return 'Joyful está preparando seu pedido.';
      case OrderStatus.ready:
        return 'Seu pedido está pronto para coleta.';
      case OrderStatus.pickedUp:
        return 'Eve Young coletou seu pedido.';
      case OrderStatus.onTheWay:
        return 'Eve Young está a caminho da sua localização.';
      case OrderStatus.nearDelivery:
        return 'Eve Young está quase chegando!';
      case OrderStatus.delivered:
        return 'Seu pedido foi entregue!';
    }
  }

  String getStatusTitle() {
    switch (_currentStatus) {
      case OrderStatus.preparing:
        return 'Preparando seu pedido';
      case OrderStatus.ready:
        return 'Pedido pronto';
      case OrderStatus.pickedUp:
        return 'Pedido coletado';
      case OrderStatus.onTheWay:
        return 'A caminho';
      case OrderStatus.nearDelivery:
        return 'Quase chegando';
      case OrderStatus.delivered:
        return 'Entregue!';
    }
  }

  void stopTracking() {
    _locationTimer?.cancel();
  }

  void dispose() {
    stopTracking();
    _locationController.close();
    _statusController.close();
  }
}

enum OrderStatus {
  preparing,
  ready,
  pickedUp,
  onTheWay,
  nearDelivery,
  delivered,
}

// Classe para representar informações do pedido
class OrderInfo {
  final String orderId;
  final String restaurantName;
  final String customerAddress;
  final String driverName;
  final String driverPhone;
  final DateTime estimatedDelivery;
  final double deliveryFee;

  OrderInfo({
    required this.orderId,
    required this.restaurantName,
    required this.customerAddress,
    required this.driverName,
    required this.driverPhone,
    required this.estimatedDelivery,
    required this.deliveryFee,
  });

  static OrderInfo getSampleOrder() {
    return OrderInfo(
      orderId: '#NEJ20089934122231',
      restaurantName: 'Joyful Restaurant',
      customerAddress: 'The Poiz Residences\n4 Meyappa Chettar Rd',
      driverName: 'Eve Young',
      driverPhone: '+258 84 123 4567',
      estimatedDelivery: DateTime.now().add(Duration(minutes: 25)),
      deliveryFee: 50.0,
    );
  }
}