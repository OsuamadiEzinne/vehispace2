import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vehispace/provider/towingbloc.dart';
import 'package:vehispace/utils/constants.dart';
import 'package:vehispace/widgets/towingrequestcard.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:vehispace/provider/appbartitle.dart';

class TowingInformationMap extends StatefulWidget {
  // final Function editOnPressed;
  // TowingInformationMap({this.editOnPressed});
  @override
  _TowingInformationMapState createState() => _TowingInformationMapState();
}

class _TowingInformationMapState extends State<TowingInformationMap> {

  List <Map<String, dynamic>> xlist = [
    {
      'Location' : 'Agege',
      'LatLng' : LatLng(6.6152237, 3.3034298)
    },
    {
      'Location' : 'Alausa',
      'LatLng' : LatLng(6.6218151, 3.3567471)
    },
    {
      'Location' : 'Adekunle/Mainland',
      'LatLng' : LatLng(6.4873581, 3.3679027)
    },
    {
      'Location' : 'Ajah',
      'LatLng' : LatLng(6.4637314, 3.5331661)
    },
    {
      'Location' : 'Anthony',
      'LatLng' : LatLng(6.463711, 3.4280944)
    },
    {
      'Location' : 'Cele/Ikotun',
      'LatLng' : LatLng(6.564003, 3.2535356)
    },
    {
      'Location' : 'Costain',
      'LatLng' : LatLng(6.4594242, 3.2048207)
    },
    {
      'Location' : 'Gbagada',
      'LatLng' : LatLng(6.5569355, 3.381713)
    },
    {
      'Location' : 'Ikeja',
      'LatLng' : LatLng(6.6051137, 3.3327517)
    },
    {
      'Location' : 'Ikorodu',
      'LatLng' : LatLng(6.6051137, 3.454467)
    },
    {
      'Location' : 'Ladipo',
      'LatLng' : LatLng(6.5383403, 3.3437686)
    },
    {
      'Location' : 'Mile 2',
      'LatLng' : LatLng(6.4659336, 3.3176028)
    },
    {
      'Location' : 'Moshalashi',
      'LatLng' : LatLng(6.610188, 3.2915211)
    },
    {
      'Location' : 'Obalande',
      'LatLng' : LatLng(6.4463603, 3.404485)
    },
    {
      'Location' : 'Okoko',
      'LatLng' : LatLng(6.4741721, 3.176361)
    },
    {
      'Location' : 'Owodo',
      'LatLng' : LatLng(6.5029822, 3.3892884)
    },
    {
      'Location' : 'Oworo',
      'LatLng' : LatLng(6.6549564, 3.3995669)
    },
    {
      'Location' : 'Super',
      'LatLng' : LatLng(6.5897463, 3.2289833)
    },
    {
      'Location' : 'Wharf 1',
      'LatLng' : LatLng(6.4530631, 3.3645287)
    },
    {
      'Location' : 'Wharf 2',
      'LatLng' : LatLng(6.64536215, 3.364964)
    },
    {
      'Location' : 'Toll Gate',
      'LatLng' : LatLng(6.599437, 3.3756053)
    },
  ];
  double cameraZoom = 10;
  // double cameraTilt = 0;
  double cameraBearing = 30;
  LatLng sourceLocation = LatLng(6.465422, 3.406448);
  LatLng destLocation = LatLng(6.4594242, 3.2048207);
  // LatLng sourceLocation = LatLng(42.7477863, -71.1699932);
  // LatLng destLocation = LatLng(42.6871386, -71.2143403);

Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polyline = {};

  Set<Factory<OneSequenceGestureRecognizer>>  gestureRecognizers () {
    var recognizers = Set<Factory<OneSequenceGestureRecognizer>>();
    recognizers.add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()));
     recognizers.add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()));
      recognizers.add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()));
    recognizers.add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()));
    recognizers.add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()));
  }

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  String gAPIKey = "AIzaSyC7mZ2Yptrj5cGFu2G-uxqScl7kZSIIYOc";

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destIcon;
  @override

  void initState () {
    super.initState();
    AppBarTitle().appBarTitle = 'Towing Information';
    setSourceAndDestIcons();
  }

  void setSourceAndDestIcons () async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 
      'assets/images/pin.png',
      );

      destIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), 
      'assets/images/pintruck.png',
      );
  }
@override


  Widget build(BuildContext context) {
    var towingBloc = Provider.of<TowingBloc>(context);
    return
//      Scaffold(
//      backgroundColor: Color(0xffe5e5e5),
//      appBar: AppBar(
//        iconTheme: IconThemeData(
//          color: Color(0xff003399),
//        ),
//        backgroundColor: Color(0xfff4f4f4),
//        centerTitle: true,
//        title: Text(
//          'My Profile',
//          style: Constants.appBarTitleColor,
//        ),
//      ),
//      body:
      Stack(
//      fit: StackFit.expand,
      children: <Widget>[

        Container(
          height: MediaQuery.of(context).size.height * 0.81,
            child:
            GoogleMap(
              initialCameraPosition: CameraPosition(
              target: sourceLocation, //LatLng(6.605874, 3.349149),
              zoom: cameraZoom,
              // tilt: cameraTilt,
              bearing: cameraBearing,
             ),
             myLocationEnabled: true,
             myLocationButtonEnabled: true,
             tiltGesturesEnabled: true,
             compassEnabled: true,
             zoomGesturesEnabled: true,
             rotateGesturesEnabled: true,
             trafficEnabled: true,
             indoorViewEnabled: true,
             gestureRecognizers: gestureRecognizers(),
             mapType: MapType.normal,
             markers: _markers,
             polylines: _polyline,
             onMapCreated: onMapCreated,
              ),
             ),
//      ListView.builder(
//      shrinkWrap: true,
//      itemCount: 1,
//      itemBuilder: (context, index) {
//        return TowingRequestCard(
//          title: 'Towing Service Requested',
//              status: 'Status: Order is being processed',
//              vehicleMake: towingBloc.towingDetails.vehicle,
//              brand: towingBloc.towingDetails.brand,
//              modelYear: towingBloc.towingDetails.model,
//              location: towingBloc.towingDetails.location,
//              destination: towingBloc.towingDetails.destination,
//              conditionOfVehicle: towingBloc.towingDetails.conditionOfVehicle,
//              casaulty: towingBloc.towingDetails.casualty,
//              additionInfo: towingBloc.towingDetails.additionalInfo ?? '',
//              dateTime: towingBloc.towingDetails.requestDate,
//              onPressed: null, //widget.editOnPressed(),
//
//        );
//      }
//    )
        ],
      );
//    );
  }
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
//    setPolylines();
  }


  void setMapPins () {
    setState(() {
      xlist.forEach((element) {
        print(element['LatLng'].toString());
        print(element['Location'].toString());
      _markers.add(Marker(
        markerId: MarkerId(element['Location']),
        position: element['LatLng'],
        icon: sourceIcon,
        ));
      });
//        _markers.add(Marker(
//          markerId: MarkerId('destPin'),
//          position: destLocation,
//          icon: destIcon,
//          ));
    });
  }

  setPolylines () async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
      gAPIKey, 
      sourceLocation.latitude, 
      sourceLocation.longitude, 
      destLocation.latitude,
      destLocation.longitude,
      );
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline (
        polylineId: PolylineId('poly'),
        color: Color(0xffff0000),
        points: polylineCoordinates,
        );
        _polyline.add(polyline);
    });
  
  }

}