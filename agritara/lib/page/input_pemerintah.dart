import 'package:flutter/material.dart';
import 'package:agritara/main.dart';
import 'package:agritara/page/halaman_pemerintah.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halaman Input Pemerintah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HalamanUtama(),
    );
  }
}


class HalamanInputPemerintah extends StatefulWidget {
  const HalamanInputPemerintah({super.key});

  final String title = 'Halaman Input Pemerintah';

  @override
  State<HalamanInputPemerintah> createState() => _StateHalamanInputPemerintah();
}

class _StateHalamanInputPemerintah extends State<HalamanInputPemerintah> {
  final _formKey = GlobalKey<FormState>();
  String _namaRequest = "";
  String _kuantitasString = "";
  int _kuantitasInt = 0;

  postData(String request, String kuantitas) async {

    var response = await http.post(
      Uri.parse('https://agritara.pythonanywhere.com/permintaan/request/'),
      // Uri.parse('http://localhost:8000/permintaan/request/'),
      // body: {

      body: {
        "request":request,
        "kuantitas_req":kuantitas,
      }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: const Text('Halaman Utama'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanUtama()),
                );
              },
            ),
            ListTile(
              title: const Text('Halaman Pemerintah'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HalamanPemerintah()),
                );
              },
            ),
            ListTile(
              title: const Text('Halaman Input Pemerintah'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HalamanInputPemerintah()),
                );
              },
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),

            child: Column(
              children: [

                // Request
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Request',
                      labelText: 'Request',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),

                    // onChanged behaviour
                    onChanged: (String? newValue) {
                      setState(() {
                        _namaRequest = newValue!;
                      });
                    },

                    // onSaved behaviour
                    onSaved: (String? newValue) {
                      setState(() {
                        _namaRequest = newValue!;
                      });
                    },

                    // Form validator
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Request tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                ),

                // Kuantitas
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: TextFormField(
                    // Only accepts number
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],

                    decoration: InputDecoration(
                      hintText: 'Kuantitas',
                      labelText: 'Kuantitas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),

                    // onChanged behaviour
                    onChanged: (String? newValue) {
                      setState(() {
                        _kuantitasString = newValue!;
                      });
                    },

                    // onSaved behaviour
                    onSaved: (String? newValue) {
                      setState(() {
                        _kuantitasString = newValue!;
                      });
                    },

                    // Form validator
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Kuantitas tidak boleh kosong!';
                      } else if (int.parse(value) == 0) {
                        return 'Kuantitas tidak boleh nol!';
                      }
                      return null;
                    },
                  ),
                ),


                // Save button
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),

                  child: const Text('Submit', style: TextStyle(color: Colors.white),),

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      
                      // Dialog box to show data has been added
                      showDialog(
                        context: context,
                        builder: (context) {
                          
                          // Dialog box
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            elevation: 15,
                            
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              width: 400,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    
                                    child: Text(
                                            'Data Request berhasil disimpan!',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                  ),

                                  const SizedBox(height: 20,),

                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                                    ),
                                    child: const Text('Kembali', style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      Navigator.pop(context);
                        
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      // Posts data to databse
                      postData(_namaRequest, _kuantitasString);

                      // Resets form
                      _formKey.currentState!.reset();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
