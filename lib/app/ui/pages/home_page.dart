import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/app/ui/controllers/driver_map_controller.dart';
import 'package:rider_app/app/ui/utils/stars_method.dart';
import 'package:rider_app/app/ui/utils/style.dart';
import 'package:rider_app/app/widgets/custom_text.dart';
import 'package:rider_app/app/widgets/rider_draggable.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DriverMapController _con = DriverMapController();

  @override
  void initState() {
    super.initState();
    //_deviceToken();
    //_updatePosition();    // Actualiar la posicion del conductor en DB cuando incia la aplicacion
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      // una vez que un widget haya terminado de compilarse
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _googleMapsWidget(),
        Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width / 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: grey, blurRadius: 17)]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white30,
                        child: ClipRRect(
                          child: Image.asset('assets/img/bill.png'),
                          borderRadius: BorderRadius.circular(50.0),
                        ),

                        //child: Icon(Icons.person_outline,size: 25,),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                              text: "Franklin Elias G.",
                              size: 18,
                              weight: FontWeight.bold,
                            ),
                            stars(rating: 4, votes: 500)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        const SafeArea(
          child: Visibility(
              visible: true, //appState.show == Show.RIDER,
              child: RiderWidget()),
        ),
      ],
    ));
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _con.initialPosition,
        onMapCreated: _con.onMapCreated,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        markers: Set<Marker>.of(_con.markers.values));
  }

  void refresh() {
    setState(() {});
  }
}
