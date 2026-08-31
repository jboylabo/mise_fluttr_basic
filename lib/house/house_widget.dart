import 'package:flutter/material.dart';

class HouseWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<HouseWidget> createState() => _HouseWidgetState();
}

class _HouseWidgetState extends State<HouseWidget> {

  bool toggle = false;

  void toggleSwitch() {
    setState(() {
      toggle = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 350,
          height: 570,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(top: 10),
                    child: SizedBox(
                      width: 330,
                      height: 330,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('images/house.jpeg', fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(40),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: IconButton(
                        onPressed: () {
                          toggleSwitch();
                        },
                        icon: toggle ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lakeshoure',
                      strutStyle: StrutStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(children: [
                      Icon(Icons.star,color: Colors.yellow,size: 20,),
                      Text('4.8 (200)',strutStyle: StrutStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                    ],)
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(padding: const EdgeInsets.only(left: 16.0, right: 16.0), child: Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,color: Colors.grey,size: 20,),
                      Text('2464 Royal Ln. Mesa, New Jersey',strutStyle: StrutStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),),
              const SizedBox(height: 8.0),
              Padding(padding: const EdgeInsets.only(left: 16.0, right: 16.0), child: Row(
                children: [
                  Row(
                    spacing: 3.0,
                    children: [
                      Icon(Icons.bed,color: Colors.grey,size: 20,),
                      Text('3 Bedrooms',strutStyle: StrutStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      Icon(Icons.bathtub_sharp,color: Colors.grey,size: 20,),
                      Text('3 Bathrooms',strutStyle: StrutStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      Icon(Icons.square_foot,color: Colors.grey,size: 20,),
                      Text('3210 Sqft',strutStyle: StrutStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),),
              const SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsetsGeometry.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('250 Night', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                    SizedBox(
                      width: 190,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {}, child: const Text('Reserve', style: TextStyle(color: Colors.white),)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
