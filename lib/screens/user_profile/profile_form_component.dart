
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbot_app/auth/user_model.dart';
import 'package:zbot_app/components/show_error_dialog.dart';
import 'package:zbot_app/components/text_form_field_styled_component.dart';
import 'package:zbot_app/resources/api_client.dart';
import 'package:zbot_app/screens/user_profile/user_profile_bloc.dart';

import 'maps_screen.dart';

class ProfileFormComponent extends StatefulWidget {
  final User user;
  final ApiClient apiClient;
  ProfileFormComponent(this.user, this.apiClient);

  @override
  _ProfileFormComponentState createState() => _ProfileFormComponentState();
}

class _ProfileFormComponentState extends State<ProfileFormComponent> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<String> _locations;
  final bioCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProfileBloc bloc = Provider.of<UserProfileBloc>(context);
    var _user = widget.user;

    return Form(
        key: _formKey,
        child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: ListView(
                  children: [
                    Text("Location:"),
                    StreamBuilder<List<String>>(
                      stream: bloc.locations,
                      builder: (context, snapshot) {
                        _locations = _user.location != null && _user.location.length > 0 ? _user.location : ["Add location"];
                        if (snapshot.hasData) {
                          _locations = snapshot.data;
                        }

                        print("_locations[0] ${_locations[0]}");

                        return TextFormField(
                          initialValue: _locations[0],
                          readOnly: true,
                          onTap: () {
                            if (!_formKey.currentState.validate()) {
                              showErrorDialog(context, "Save the unsaved data first!");
                              return;
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => MapsScreen()
                            ));
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        );
                      }
                    ),

                    StreamBuilder<String>(
                      stream: bloc.username,
                      builder: (context, snapshot) {
                        return TextFormFieldStyled(
                          initialValue: _user.username,
                          textCapitalization: TextCapitalization.words,
                          labelText: "username",
                          readOnly: true,
                        );
                      }
                    ),

                    StreamBuilder<String>(
                      stream: bloc.fullName,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          fullNameCtrl.text = snapshot.data;
                        }

                        return TextFormFieldStyled(
                          initialValue: _user.full_name,
                          onChanged: bloc.changeFullName,
                          textCapitalization: TextCapitalization.words,
                          labelText: "full name",
                          validator: (String val) => val.validationForName,
                          autoValidate: true,
                        );
                      }
                    ),

                    StreamBuilder<String>(
                        stream: bloc.email,
                        builder: (context, snapshot) {
                          return TextFormFieldStyled(
                            initialValue: _user.email,
                            onChanged: bloc.changeEmail,
                            textCapitalization: TextCapitalization.words,
                            labelText: "email",
                            readOnly: true,
                          );
                        }
                    ),

                    StreamBuilder<String>(
                        stream: bloc.bio,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bioCtrl.text = snapshot.data;
                          }
                          return TextFormFieldStyled(
                            initialValue: _user.bio,
                            onChanged: bloc.changeBio,
                            textCapitalization: TextCapitalization.words,
                            labelText: "bio",
                          );
                        }
                    ),

                    RaisedButton(
                      onPressed: _isLoading ? () => null : () {_submit(context);},
                      child: new Text(
                        _isLoading ? "Processing" : "Submit"
                      ),
                    ),
                  ],
                ),
              ),

            ]
        )
    );
  }

  Future<void> _submit(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Processing Data')));
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> body = {
      "full_name": fullNameCtrl.text,
      "bio": bioCtrl.text,
      "image": "https://i.imgur.com/8X0r6Uz.png",
      "locations": _locations,
    };
    print(body.toString());


    try {
      var data = await widget.apiClient.post("/me", body);
      print(data.toString());
    } catch(e) {
      print("post error: ${e.toString()}");
    }

    return;
  }
}


extension Validations on String {
  String get validationForName {
    if (this.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  String get validationForMobile {
    if (this.isEmpty) {
      return 'Field cannot be empty';
    }

    Pattern pattern = r'^(04)\d{8}$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(this)) ? 'Please enter a valid mobile number' : null;
  }

  String get validationForEmail {
    String value = this;
    if (value.isEmpty) {
      return 'Field cannot be empty';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? 'Please enter a valid email' : null;
  }
}
