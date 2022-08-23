import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/contact_repository.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _userUpdated = false;
  late Contact _updatedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _updatedContact = Contact();
    } else {
      _updatedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _updatedContact.name;
      _emailController.text = _updatedContact.email;
      _phoneController.text = _updatedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _updatedContact.name.isNotEmpty
                ? _updatedContact.name
                : 'Novo Contato',
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_updatedContact.phone.isEmpty || _updatedContact.phone == '') {
              FocusScope.of(context).requestFocus(_phoneFocus);
            }

            if (_updatedContact.email.isEmpty || _updatedContact.email == '') {
              FocusScope.of(context).requestFocus(_emailFocus);
            }

            if (_updatedContact.name.isEmpty || _updatedContact.name == '') {
              FocusScope.of(context).requestFocus(_nameFocus);
            }

            if (_updatedContact.name.isNotEmpty &&
                _updatedContact.name != '' &&
                _updatedContact.email.isNotEmpty &&
                _updatedContact.email != '' &&
                _updatedContact.phone.isNotEmpty &&
                _updatedContact.phone != '') {
              Navigator.pop(context, _updatedContact);
            }
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _updatedContact.image.isNotEmpty
                          ? FileImage(File(_updatedContact.image))
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                      // https://www.flaticon.com/free-icons/person // person icons // Person icons created by Ilham Fitrotul Hayat - Flaticon
                    ),
                  ),
                ),
                onTap: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _updatedContact.image = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                onChanged: (name) {
                  _userUpdated = true;
                  setState(() {
                    _updatedContact.name = name;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (email) {
                  _userUpdated = true;
                  _updatedContact.email = email;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
                onChanged: (phone) {
                  _userUpdated = true;
                  _updatedContact.phone = phone;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userUpdated) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar Alterações?'),
            content: const Text('Se sair, as alterações serão perdidas!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Sim'),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
