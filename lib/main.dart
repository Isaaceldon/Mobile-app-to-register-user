import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import '../services/database_service.dart';
import '../views/contact_list_page.dart';
import 'models/contact.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Ajouter un contact", style: TextStyle(fontWeight: FontWeight.bold),),
          Form(
            key: _formKey,
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Le nom & prénom du contact",
                      labelText: "Nom & Prénom *"
                  ),
                  validator: (String? value) {
                    return (value == null || value == "") ?
                    "Ce champ est obligatoire" : null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: "Numéro de téléphone du contact",
                      labelText: "Numéro de Téléphone *"
                  ),
                  validator: (String? value) {
                    return (value == null || value == "") ?
                    "Ce champ est obligatoire" : null;
                  },
                )
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                DatabaseService dbService = DatabaseService();
                await dbService.insertContact(Contact(fullName: _fullNameController.text,
                    phoneNumber: _phoneNumberController.text));
                Fluttertoast.showToast(
                  msg: "Le contact a été enregistré avec succès",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
                _fullNameController.text = "";
                _phoneNumberController.text = "";
              },
              child: Text('Enregistrer')
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactListPage()),
                );
              },
              child: Text("Liste des contacts")
          )
        ],
      ),

    );
  }
}
