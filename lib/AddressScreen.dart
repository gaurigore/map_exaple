import 'package:flutter/material.dart';
import 'package:map_example/MapPage.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String _address = "";
  String place = "";
  String street = "";
  String area = "";
  String city = "";
  String state = "";
  String zipcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Locator"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Please enter accurate address to get accuracy",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Place*'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please enter place*";
                        }
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            place = value;
                          });
                        }
                      },
                    ),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'Street'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              street = value;
                            });
                          }
                        }),
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Area/landmark'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              area = value;
                            });
                          }
                        }),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'City'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              city = value;
                            });
                          }
                        }),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'State'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              state = value;
                            });
                          }
                        }),
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Zip Code'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              zipcode = value;
                            });
                          }
                        }),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (place.isNotEmpty) {
                              _address = "$place";
                            }
                            if (street.isNotEmpty) {
                              _address += ", $street";
                            }
                            if (area.isNotEmpty) {
                              _address += ", $area";
                            }
                            if (city.isNotEmpty) {
                              _address += ", $city";
                            }
                            if (state.isNotEmpty) {
                              _address += ", $state";
                            }
                            if (zipcode.isNotEmpty) {
                              _address += ", $zipcode";
                            }
                            if (_address.isNotEmpty) {
                              print(_address);
                              // _formKey.currentState!.reset();
                            }
                            if (_address != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MapPage(address: _address)));
                            }
                            _formKey.currentState!.reset();
                          }
                        },
                        child: const Text("Go"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
