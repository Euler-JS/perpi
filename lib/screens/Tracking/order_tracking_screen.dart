import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:perpi_app/screens/constants.dart';
import 'dart:async';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late GoogleMapController mapController;
  bool showDetails = false;
  
  // Coordenadas para Maputo (você pode ajustar conforme necessário)
  static const LatLng _centerMaputo = LatLng(-25.9692, 32.5732);
  static const LatLng _restaurantLocation = LatLng(-25.9662, 32.5702);
  static const LatLng _deliveryLocation = LatLng(-25.9722, 32.5762);
  static const LatLng _currentDriverLocation = LatLng(-25.9682, 32.5732);

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _createMarkersAndRoute();
  }

  void _createMarkersAndRoute() {
    // Marcador do restaurante
    _markers.add(
      Marker(
        markerId: MarkerId('restaurant'),
        position: _restaurantLocation,
        infoWindow: InfoWindow(
          title: 'Joyful Restaurant',
          snippet: 'Seu pedido foi preparado aqui',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    // Marcador do destino
    _markers.add(
      Marker(
        markerId: MarkerId('destination'),
        position: _deliveryLocation,
        infoWindow: InfoWindow(
          title: 'The Poiz Residences',
          snippet: '4 Meyappa Chettar Rd',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Marcador do entregador
    _markers.add(
      Marker(
        markerId: MarkerId('driver'),
        position: _currentDriverLocation,
        infoWindow: InfoWindow(
          title: 'Eve Young - Entregador',
          snippet: 'A caminho da sua localização',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    // Criar rota (linha entre os pontos)
    _polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: [
          _restaurantLocation,
          _currentDriverLocation,
          _deliveryLocation,
        ],
        color: Colors.orange,
        width: 4,
        patterns: [],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Maps
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _centerMaputo,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          
          // AppBar transparente
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          
          // Botão de localização
          Positioned(
            right: 16,
            top: 120,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.my_location, color: Colors.black),
                onPressed: () {
                  mapController.animateCamera(
                    CameraUpdate.newLatLng(_currentDriverLocation),
                  );
                },
              ),
            ),
          ),
          
          // Card de informações deslizante
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barra indicadora
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        // Status principal
                        _buildMainStatus(),
                        
                        SizedBox(height: 24),
                        
                        // Timeline de entrega
                        _buildDeliveryTimeline(),
                        
                        SizedBox(height: 24),
                        
                        // Informações do entregador
                        _buildDriverInfo(),
                        
                        SizedBox(height: 24),
                        
                        // Botão "Ver todos os detalhes"
                        if (!showDetails) _buildViewDetailsButton(),
                        
                        // Detalhes expandidos
                        if (showDetails) _buildExpandedDetails(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatus() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delivery_dining,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preparando seu pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Chega entre 11:23 PM - 12:01 AM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Joyful está preparando seu pedido.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cronograma de entrega',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        
        _buildTimelineItem(
          icon: Icons.restaurant,
          title: 'Chegando hoje!',
          subtitle: 'Sua entrega, #NEJ20089934122231\nde Atlanta, está chegando hoje!',
          time: 'Fev 23 às 9:50pm',
          isActive: true,
          isCompleted: false,
        ),
        
        _buildTimelineItem(
          icon: Icons.local_shipping,
          title: 'Foi enviado',
          subtitle: 'O pacote está aguardando coleta',
          time: 'Fev 20',
          isActive: false,
          isCompleted: true,
        ),
        
        _buildTimelineItem(
          icon: Icons.send,
          title: 'Foi enviado',
          subtitle: 'O pacote está aguardando coleta',
          time: 'Fev 17',
          isActive: false,
          isCompleted: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.blue
                  : isCompleted
                      ? Colors.green
                      : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/driver_avatar.png'), // Adicione esta imagem
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.white), // Fallback
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eve Young',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Entregador',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.message,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewDetailsButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            showDetails = true;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ver todos os detalhes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalhes do pedido',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        
        _buildDetailItem('Número do pedido', '#NEJ20089934122231'),
        _buildDetailItem('Tempo estimado', '7 mins'),
        _buildDetailItem('Distância', '2.5 km'),
        _buildDetailItem('Taxa de entrega', '50 MT'),
        
        SizedBox(height: 24),
        
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showDetails = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Vamos lá',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}