import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/core/widgets/firestore_functions.dart';

class EditProfile {
  static void editProfileForm(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Edit Profile'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        icon: Icon(Icons.message),
                      ),
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        icon: Icon(Icons.email),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  String id = FirebaseAuth.instance.currentUser!.uid;

                  Map<String, dynamic> userData = {};
                  if (firstNameController.text.isNotEmpty) {
                    userData['firstName'] = firstNameController.text;
                  }
                  if (lastNameController.text.isNotEmpty) {
                    userData['lastName'] = lastNameController.text;
                  }
                  if (phoneController.text.isNotEmpty) {
                    userData['phone'] = phoneController.text;
                  }
                  if (addressController.text.isNotEmpty) {
                    userData['address'] = addressController.text;
                  }

                  FireStoreFunctions.updateUser(id,
                      firstName: userData['firstName'],
                      lastName: userData['lastName'],
                      phone: userData['phone'],
                      address: userData['address']);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }
}
