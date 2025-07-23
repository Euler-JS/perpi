import 'package:flutter/material.dart';
import 'package:perpi_app/models/delivery_tracking.dart';
import 'package:perpi_app/screens/constants.dart';
import 'dart:math' as math;

// Para usar Google Maps real, adicione no pubspec.yaml:
// google_maps_flutter: ^2.5.0
// location: ^5.0.3

class TrackingScreen extends StatefulWidget {
  final DeliveryTracking? delivery;

  const TrackingScreen({super.key, this.delivery});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _routeController;
  late DeliveryTracking delivery;
  bool _showOrderDetails = false;

  @override
  void initState() {
    super.initState();
    delivery = widget.delivery ?? mockDeliveryTracking;
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _routeController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        // toolbarHeight: 40,
      ),
      body: Stack(
        children: [
          // Mapa personalizado
          _buildCustomMap(size),
          
          // Header com botões
          _buildHeader(),
          
          // Informações da entrega na parte inferior
          _buildDeliveryInfo(),
          
          // Modal de detalhes do pedido
          if (_showOrderDetails) _buildOrderDetailsModal(),
        ],
      ),
    );
  }

  Widget _buildCustomMap(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade200,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Simulação das ruas
          _buildStreetPattern(size),
          
          // Rota do entregador
          _buildDeliveryRoute(size),
          
          // Marcador do cliente
          _buildCustomerMarker(size),
          
          // Marcador do entregador (animado)
          _buildDriverMarker(size),
        ],
      ),
    );
  }

  Widget _buildStreetPattern(Size size) {
    return CustomPaint(
      size: size,
      painter: StreetPatternPainter(),
    );
  }

  Widget _buildDeliveryRoute(Size size) {
    return AnimatedBuilder(
      animation: _routeController,
      builder: (context, child) {
        return CustomPaint(
          size: size,
          painter: DeliveryRoutePainter(_routeController.value),
        );
      },
    );
  }

  Widget _buildDriverMarker(Size size) {
    // Posição do entregador (animada)
    final driverX = size.width * 0.3;
    final driverY = size.height * 0.6;

    return Positioned(
      left: driverX - 25,
      top: driverY - 25,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showOrderDetails = !_showOrderDetails;
          });
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.3 * _pulseController.value),
                    blurRadius: 20 * _pulseController.value,
                    spreadRadius: 5 * _pulseController.value,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: Image.network(
                    delivery.driverPhoto,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: buttonColor,
                        child: const Icon(
                          Icons.delivery_dining,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomerMarker(Size size) {
    // Posição do cliente
    final customerX = size.width * 0.75;
    final customerY = size.height * 0.25;

    return Positioned(
      left: customerX - 20,
      top: customerY - 40,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Destino",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: textPrimary,
                size: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Rastreio do Pedido",
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // Função de ajuda
              },
              icon: Icon(
                Icons.help_outline,
                color: textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status e tempo estimado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _getStatusText(delivery.status),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Chegando entre 11:23 PM - 12:01 AM",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        delivery.estimatedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Informações do entregador
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(delivery.driverPhoto),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: delivery.driverPhoto.isEmpty 
                    ? Icon(Icons.person, color: textSecondary)
                    : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.driverName,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Entregador",
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Função de chat
                          _showChatDialog();
                        },
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Função de chamada
                          _makePhoneCall();
                        },
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Botão de ver detalhes
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showOrderDetails = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 20,
                      color: textPrimary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Ver Detalhes do Pedido",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsModal() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle do modal
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header do modal
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Detalhes do Pedido",
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showOrderDetails = false;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Conteúdo scrollável
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informações do pedido
                    _buildOrderInfo(),
                    
                    const SizedBox(height: 20),
                    
                    // Status do pedido
                    _buildOrderStatus(),
                    
                    const SizedBox(height: 20),
                    
                    // Items do pedido
                    _buildOrderItems(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pedido ${delivery.orderId}",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  delivery.paymentMethod,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  delivery.deliveryAddress,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ${delivery.totalAmount.toStringAsFixed(2)}MT",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Status da Entrega",
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ...delivery.trackingSteps.map((step) => _buildStatusStep(step)).toList(),
      ],
    );
  }

  Widget _buildStatusStep(TrackingStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: step.isCompleted ? accentColor : Colors.grey.shade300,
              shape: BoxShape.circle,
              border: step.isCurrent 
                ? Border.all(color: accentColor, width: 3)
                : null,
            ),
            child: step.isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 12)
              : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: step.isCompleted ? textPrimary : textSecondary,
                    fontSize: 16,
                    fontWeight: step.isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  step.description,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${step.timestamp.hour.toString().padLeft(2, '0')}:${step.timestamp.minute.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Items do Pedido",
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ...delivery.items.map((item) => _buildOrderItem(item)).toList(),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.image, color: textSecondary),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Quantidade: ${item.quantity}",
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${item.price.toStringAsFixed(2)}MT",
            style: TextStyle(
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return "Pendente";
      case DeliveryStatus.confirmed:
        return "Confirmado";
      case DeliveryStatus.preparing:
        return "Preparando";
      case DeliveryStatus.shipped:
        return "A Caminho";
      case DeliveryStatus.delivered:
        return "Entregue";
      case DeliveryStatus.cancelled:
        return "Cancelado";
    }
  }

  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Chat com ${delivery.driverName}",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Funcionalidade de chat será implementada em breve.",
            style: TextStyle(
              color: textSecondary,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Ligar para ${delivery.driverName}",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Número: ${delivery.driverPhone}",
            style: TextStyle(
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Implementar chamada telefônica
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Ligar"),
            ),
          ],
        );
      },
    );
  }
}

// Painter para desenhar o padrão das ruas
class StreetPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Ruas horizontais
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Ruas verticais
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Painter para desenhar a rota de entrega
class DeliveryRoutePainter extends CustomPainter {
  final double progress;

  DeliveryRoutePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffFF6B35)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dottedPaint = Paint()
      ..color = const Color(0xffFF6B35).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Pontos da rota
    final startPoint = Offset(size.width * 0.1, size.height * 0.8);
    final midPoint1 = Offset(size.width * 0.3, size.height * 0.6);
    final midPoint2 = Offset(size.width * 0.6, size.height * 0.4);
    final endPoint = Offset(size.width * 0.75, size.height * 0.25);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(
      midPoint1.dx, midPoint1.dy,
      midPoint2.dx, midPoint2.dy,
    );
    path.quadraticBezierTo(
      midPoint2.dx, midPoint2.dy,
      endPoint.dx, endPoint.dy,
    );

    // Desenhar a rota completa pontilhada
    _drawDottedPath(canvas, path, dottedPaint);

    // Desenhar o progresso da rota
    final progressPath = _extractPathProgress(path, progress);
    canvas.drawPath(progressPath, paint);
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final metric = path.computeMetrics().first;
    const dashLength = 8.0;
    const spaceLength = 6.0;
    double distance = 0.0;

    while (distance < metric.length) {
      final start = metric.getTangentForOffset(distance);
      final end = metric.getTangentForOffset(distance + dashLength);
      
      if (start != null && end != null) {
        canvas.drawLine(start.position, end.position, paint);
      }
      
      distance += dashLength + spaceLength;
    }
  }

  Path _extractPathProgress(Path path, double progress) {
    final metric = path.computeMetrics().first;
    final extractPath = metric.extractPath(0, metric.length * progress);
    return extractPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is DeliveryRoutePainter && oldDelegate.progress != progress;
  }
}