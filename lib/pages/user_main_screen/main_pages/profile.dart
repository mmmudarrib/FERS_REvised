import 'package:fers/database/auth_methods.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/widgets/custom_textformfield.dart';
import 'package:fers/widgets/custom_toast.dart';
import 'package:fers/widgets/password_textformfield.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_validator.dart';
import '../../auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool edit = false;
  bool loading = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  void initState() {
    edit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _name.text = UserLocalData.getName;
    if (UserLocalData.getPhone != '') {
      _phone.text = UserLocalData.getPhone;
    }
    if (UserLocalData.getCity != '') {
      _city.text = UserLocalData.getCity;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: (!edit)
                  ? Text(_name.text)
                  : CustomTextFormField(
                      controller: _name,
                      hint: "Name",
                      title: "Name",
                    ),
            ),
          ),
          Center(
            child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
                title: Text(UserLocalData.getEmail)),
          ),
          Center(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: (!edit)
                  ? (UserLocalData.getPhone == '')
                      ? const Text("Phone Number")
                      : Text(_phone.text)
                  : CustomTextFormField(
                      controller: _phone,
                      hint: "Phone Number",
                      title: "Phone Number",
                    ),
            ),
          ),
          Center(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: (!edit)
                  ? (UserLocalData.getCity == '')
                      ? const Text("City Name")
                      : Text(_city.text)
                  : CustomTextFormField(
                      controller: _city,
                      hint: "City Name",
                      title: "City Name",
                    ),
            ),
          ),
          (!edit)
              ? SizedBox(
                  width: 200,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        edit = true;
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                  ),
                )
              : SizedBox(
                  width: 200,
                  child: TextButton.icon(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      bool done = await UserAPI()
                          .updateUser(_name.text, _phone.text, _city.text);
                      if (done) {
                        setState(() {
                          edit = false;
                          loading = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
                ),
          (!edit)
              ? SizedBox(
                  width: 200,
                  child: TextButton.icon(
                    onPressed: () {
                      AlertDialog alert = AlertDialog(
                        title: const Text("Delete Account"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Are you sure you want to delete account?"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () async {
                              Navigator.pop(context);
                              AlertDialog alert = AlertDialog(
                                title: const Text("Delete Account"),
                                content: (loading)
                                    ? const Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        ),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                              "Please Enter your password?"),
                                          PasswordTextFormField(
                                              controller: _password,
                                              validator: (String? value) =>
                                                  CustomValidator.isEmpty(
                                                      value)),
                                        ],
                                      ),
                                actions: [
                                  TextButton(
                                    child: const Text("Delete"),
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      bool done = await AuthMethods()
                                          .deleteUser(_password.text);
                                      if (done) {
                                        CustomToast.showSnackBar(
                                            context: context,
                                            text: "Account Deleted");
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const LoginScreen()));
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                  ),
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            },
                          ),
                        ],
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
