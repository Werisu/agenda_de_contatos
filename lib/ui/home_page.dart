import 'dart:io';

import 'package:contatos_de_pessoas/helpars/contatos_helpars.dart';
import 'package:contatos_de_pessoas/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();


  @override
  void initState() {
    super.initState();

    Contact c = Contact();
    c.id = 1;
    c.name = "Wellysson Rocha";
    c.email = "wellysson.rocha@estudante.ifto.edu.br";
    c.phone = "62992510372";
    c.image = null;
    helper.updateContact(c);

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].image != null ?
                    FileImage(File(contacts[index].image)) :
                        AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        contacts[index].name ?? "",
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    Text(
                        contacts[index].email ?? "",
                        style: TextStyle(
                            fontSize: 12.0,
                        )
                    ),
                    Text(
                        contacts[index].phone ?? "",
                        style: TextStyle(
                          fontSize: 18.0,
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Ligar",
                            style: TextStyle(
                                color: Colors.green, fontSize: 20.0
                            ),
                          ),
                          onPressed: (){
                            launch("tel:${contacts[index].phone}");
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Editar",
                            style: TextStyle(
                                color: Colors.green, fontSize: 20.0
                            ),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Ecluir",
                            style: TextStyle(
                                color: Colors.green, fontSize: 20.0
                            ),
                          ),
                          onPressed: (){
                            helper.deleteContact(contacts[index].id);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      )
                    ],
                ),
              );
            },
          );
        }
    );
  }
  
  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context)=>contactPage(contact: contact),
        )
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

}
