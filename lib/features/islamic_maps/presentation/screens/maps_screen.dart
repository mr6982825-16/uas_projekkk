import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/maps_provider.dart';
import '../../data/models/place_model.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapsProvider>(context, listen: false).fetchUserLocation();
    });
  }

  void _openGoogleMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=\$lat,\$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }

  void _showPlaceDetails(BuildContext context, PlaceModel place, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place.name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    "\${place.rating} (\${place.userRatingsTotal} ulasan)",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                place.vicinity,
                style: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openGoogleMaps(place.latitude, place.longitude);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text("Rute ke Lokasi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      Provider.of<MapsProvider>(context, listen: false).clearSelectedPlace();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Islamic Maps",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Consumer<MapsProvider>(
        builder: (context, provider, child) {
          
          // Listener for bottom sheet
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.selectedPlace != null) {
              _showPlaceDetails(context, provider.selectedPlace!, theme);
            }
          });

          if (provider.isLoading && provider.currentPosition == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage.isNotEmpty && provider.currentPosition == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 15),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => provider.fetchUserLocation(),
                      child: const Text("Coba Lagi"),
                    )
                  ],
                ),
              ),
            );
          }

          final initialPos = CameraPosition(
            target: LatLng(
              provider.currentPosition?.latitude ?? -6.200000, 
              provider.currentPosition?.longitude ?? 106.816666
            ),
            zoom: 15.0,
          );

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialPos,
                onMapCreated: provider.onMapCreated,
                markers: provider.allMarkers,
                myLocationEnabled: false, // We use custom marker
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
              
              // Filter Chips
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua', provider, theme),
                      const SizedBox(width: 10),
                      _buildFilterChip('Masjid', provider, theme),
                      const SizedBox(width: 10),
                      _buildFilterChip('Halal Food', provider, theme),
                    ],
                  ),
                ),
              ),

              if (provider.isLoading)
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<MapsProvider>(
        builder: (context, provider, child) {
          return FloatingActionButton(
            backgroundColor: theme.primaryColor,
            onPressed: () => provider.recenterToUser(),
            child: const Icon(Icons.my_location, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, MapsProvider provider, ThemeData theme) {
    final isSelected = provider.currentFilter == label;
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          provider.fetchPlaces(label);
        }
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.primaryColor,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
