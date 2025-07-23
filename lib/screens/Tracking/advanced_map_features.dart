// lib/screens/Tracking/advanced_map_features.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:perpi_app/screens/constants.dart';

class AdvancedMapFeatures extends StatefulWidget {
  const AdvancedMapFeatures({super.key});

  @override
  State<AdvancedMapFeatures> createState() => _AdvancedMapFeaturesState();
}

class _AdvancedMapFeaturesState extends State<AdvancedMapFeatures> {
  MapController mapController = MapController();
  String selectedTileProvider = 'osm';
  bool showTraffic = false;
  bool showRestaurants = true;

  // Diferentes provedores de tiles
  final Map<String, Map<String, String>> tileProviders = {
    'osm': {
      'name': 'OpenStreetMap',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    },
    'cartodb_light': {
      'name': 'CartoDB Light',
      'url': 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
    },
    'cartodb_dark': {
      'name': 'CartoDB Dark',
      'url': 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
    },
    'esri_satellite': {
      'name': 'Satellite',
      'url': 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    },
  };

  // Pontos de interesse em Maputo
  final List<PointOfInterest> pointsOfInterest = [
    PointOfInterest(
      name: "Restaurante Zambi",
      position: LatLng(-25.9686, 32.5804),
      type: POIType.restaurant,
      description: "Restaurante tradicional moçambicano",
    ),
    PointOfInterest(
      name: "Mercado Central",
      position: LatLng(-25.9686, 32.5804),
      type: POIType.market,
      description: "Principal mercado de Maputo",
    ),
    PointOfInterest(
      name: "Farmácia Moderna",
      position: LatLng(-25.9650, 32.5890),
      type: POIType.pharmacy,
      description: "Farmácia 24 horas",
    ),
    PointOfInterest(
      name: "Posto Shell",
      position: LatLng(-25.9710, 32.5720),
      type: POIType.gasStation,
      description: "Posto de combustível",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Mapa principal
          _buildAdvancedMap(),
          
          // Controles do mapa
          _buildMapControls(),
          
          // Seletor de estilo
          _buildStyleSelector(),
          
          // Botões de ação
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAdvancedMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(-25.9692, 32.5732), // Centro de Maputo
        initialZoom: 14.0,
        minZoom: 10.0,
        maxZoom: 18.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        onTap: (tapPosition, point) {
          _showLocationInfo(point);
        },
      ),
      children: [
        // Camada de tiles
        TileLayer(
          urlTemplate: tileProviders[selectedTileProvider]!['url']!,
          userAgentPackageName: 'com.nutrigraus.perpi_app',
          subdomains: selectedTileProvider == 'cartodb_light' || 
                      selectedTileProvider == 'cartodb_dark'
              ? ['a', 'b', 'c', 'd']
              : [],
        ),
        
        // Camada de tráfego (simulada)
        if (showTraffic) _buildTrafficLayer(),
        
        // Pontos de interesse
        if (showRestaurants) _buildPOILayer(),
        
        // Marcadores de entrega
        _buildDeliveryMarkers(),
        
        // Rota de entrega
        _buildDeliveryRoute(),
        
        // Atribuição
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              tileProviders[selectedTileProvider]!['name']!,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrafficLayer() {
    return PolylineLayer(
      polylines: [
        // Simulação de trânsito intenso (vermelho)
        Polyline(
          points: [
            LatLng(-25.9680, 32.5750),
            LatLng(-25.9680, 32.5850),
          ],
          color: Colors.red,
          strokeWidth: 6.0,
        ),
        // Trânsito moderado (amarelo)
        Polyline(
          points: [
            LatLng(-25.9700, 32.5700),
            LatLng(-25.9650, 32.5700),
          ],
          color: Colors.orange,
          strokeWidth: 6.0,
        ),
        // Trânsito livre (verde)
        Polyline(
          points: [
            LatLng(-25.9600, 32.5800),
            LatLng(-25.9550, 32.5900),
          ],
          color: Colors.green,
          strokeWidth: 6.0,
        ),
      ],
    );
  }

  Widget _buildPOILayer() {
    return MarkerLayer(
      markers: pointsOfInterest.map((poi) {
        return Marker(
          point: poi.position,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showPOIDetails(poi),
            child: Container(
              decoration: BoxDecoration(
                color: _getPOIColor(poi.type),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getPOIIcon(poi.type),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeliveryMarkers() {
    return MarkerLayer(
      markers: [
        // Entregador
        Marker(
          point: LatLng(-25.9692, 32.5732),
          width: 60,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        // Destino
        Marker(
          point: LatLng(-25.9653, 32.5892),
          width: 60,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryRoute() {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: [
            LatLng(-25.9692, 32.5732),
            LatLng(-25.9680, 32.5800),
            LatLng(-25.9660, 32.5850),
            LatLng(-25.9653, 32.5892),
          ],
          color: buttonColor,
          strokeWidth: 4.0,
          pattern: const StrokePattern.dotted(),
        ),
      ],
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      child: Column(
        children: [
          _buildControlButton(
            icon: Icons.my_location,
            onPressed: () {
              mapController.move(LatLng(-25.9692, 32.5732), 15.0);
            },
          ),
          const SizedBox(height: 10),
          _buildControlButton(
            icon: showTraffic ? Icons.traffic : Icons.traffic_outlined,
            onPressed: () {
              setState(() {
                showTraffic = !showTraffic;
              });
            },
            isActive: showTraffic,
          ),
          const SizedBox(height: 10),
          _buildControlButton(
            icon: showRestaurants ? Icons.restaurant : Icons.restaurant_outlined,
            onPressed: () {
              setState(() {
                showRestaurants = !showRestaurants;
              });
            },
            isActive: showRestaurants,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? buttonColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isActive ? Colors.white : textPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildStyleSelector() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 20,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedTileProvider,
            isExpanded: true,
            icon: Icon(Icons.map_outlined, color: textPrimary),
            style: TextStyle(color: textPrimary, fontSize: 12),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedTileProvider = newValue;
                });
              }
            },
            items: tileProviders.keys.map<DropdownMenuItem<String>>((String key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(
                  tileProviders[key]!['name']!,
                  style: const TextStyle(fontSize: 11),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 30,
      right: 20,
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              _showDirections();
            },
            backgroundColor: accentColor,
            child: const Icon(Icons.directions, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _shareLocation();
            },
            backgroundColor: buttonColor,
            child: const Icon(Icons.share_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Color _getPOIColor(POIType type) {
    switch (type) {
      case POIType.restaurant:
        return Colors.red;
      case POIType.market:
        return Colors.green;
      case POIType.pharmacy:
        return Colors.blue;
      case POIType.gasStation:
        return Colors.orange;
    }
  }

  IconData _getPOIIcon(POIType type) {
    switch (type) {
      case POIType.restaurant:
        return Icons.restaurant;
      case POIType.market:
        return Icons.store;
      case POIType.pharmacy:
        return Icons.local_pharmacy;
      case POIType.gasStation:
        return Icons.local_gas_station;
    }
  }

  void _showLocationInfo(LatLng point) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Localização"),
        content: Text(
          "Latitude: ${point.latitude.toStringAsFixed(6)}\n"
          "Longitude: ${point.longitude.toStringAsFixed(6)}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPOIDetails(PointOfInterest poi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(poi.name),
        content: Text(poi.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navegar para o POI
              mapController.move(poi.position, 16.0);
            },
            child: const Text("Ir para lá"),
          ),
        ],
      ),
    );
  }

  void _showDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Direções: Funcionalidade seria implementada com API de rotas"),
      ),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Localização compartilhada!"),
      ),
    );
  }
}

// Modelo para pontos de interesse
class PointOfInterest {
  final String name;
  final LatLng position;
  final POIType type;
  final String description;

  PointOfInterest({
    required this.name,
    required this.position,
    required this.type,
    required this.description,
  });
}

enum POIType {
  restaurant,
  market,
  pharmacy,
  gasStation,
}

// Widget para demonstrar as funcionalidades avançadas
class AdvancedMapDemo extends StatelessWidget {
  const AdvancedMapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.1), buttonColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mapa Avançado",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Estilos, tráfego, pontos de interesse",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureChip("4 Estilos de Mapa", Icons.layers),
              _buildFeatureChip("Informações de Tráfego", Icons.traffic),
              _buildFeatureChip("Pontos de Interesse", Icons.place),
              _buildFeatureChip("Direções GPS", Icons.navigation),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdvancedMapFeatures(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Abrir Mapa Avançado",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accentColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}