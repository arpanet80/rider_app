import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:rider_app/app/ui/utils/map_style.dart';

class DriverMapController {
  late BuildContext context;
  late Function refresh;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(-19.585458, -65.743180), zoom: 11.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late Position _position;
  // ignore: unused_field
  late StreamSubscription<Position> _positionString;
  late BitmapDescriptor markerDriver;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    checkGPS();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    controller.setMapStyle(mapStyle);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = (await Geolocator.getLastKnownPosition())!;
      centerPosition();
      addMarker('Driver', _position.latitude, _position.longitude,
          'Tu posicion', '', markerDriver);

      refresh();
      _positionString = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        _position = position;
        addMarker('Driver', _position.latitude, _position.longitude,
            'Tu posicion', '', markerDriver);
        animateCameraToPosition(_position.latitude, _position.longitude);
        refresh();
      });
    } catch (error) {
      //print('Error en la localizacion: $error');
    }
  }

  void centerPosition() {
    // ignore: unnecessary_null_comparison
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    } else {
      // mostrar un snackbar
    }
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      //print('GPS Activado');
      updateLocation();
    } else {
      //print('GPS Desactivado');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        //print('Usuario activo GPS');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    // ignore: unnecessary_null_comparison
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 17)));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        rotation: _position.heading);

    markers[id] = marker;
  }
}
