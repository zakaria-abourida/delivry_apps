import '../../Constant.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import '../widget/ConditionGeneral.dart';
import '../repository/user_repository.dart' as userRepo;
import '../pages/home.dart';

class PreAuthScreen extends StatefulWidget {
  PreAuthScreen({Key key}) : super(key: key);

  @override
  _PreAuthScreenState createState() => _PreAuthScreenState();
}

class _PreAuthScreenState extends State<PreAuthScreen> {
  bool checkValue = false;

  @override
  void initState() {
    getNextPage();
    super.initState();
  }

  void getNextPage() async {
    if (userRepo.currentUser.value.apiToken != null) {
      await WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/Home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*  leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: Constants.primaryColor,
            // Within the SecondRoute widget
            onPressed: () {
              Navigator.pop(context);
            }), */
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/img/logo.png',
          fit: BoxFit.fitHeight,
          height: 130,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Container(
                    height: 350,
                    color: Colors.white,
                    child: Image.asset(
                      'assets/img/icon-moto.png',
                      fit: BoxFit.fitHeight,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
            ),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        onChanged: (bool value) {
                          setState(() {
                            checkValue = value;
                          });
                        },
                        value: checkValue,
                        activeColor: Constants.primaryColor,
                      ),
                      Text(
                        "J'ai lu et accepté les règles de",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          ConditionGenerale.openDialog(context);
                        },
                        child: Text(
                          " confidentialité",
                          style: TextStyle(
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    height: 37,
                    minWidth: 280,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "C'EST PARTI",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Constants.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (checkValue == true) {
                        //Navigator.of(context).pushReplacementNamed('/Login');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginWidget()));
                      }
                    },
                  ),
                  FlatButton(
                    height: 37,
                    minWidth: 280,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "J'AI DEJA UN COMPTE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Constants.primaryColor,
                      ),
                    ),
                    color: Colors.grey[200],
                    textColor: Colors.white,
                    onPressed: () {
                      if (checkValue == true) {
                        //Navigator.of(context).pushReplacementNamed('/Login');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginWidget()));
                      }
                      // Navigator.of(context).pop();
                    },
                  ),
                  // SizedBox(
                  //   height: 50,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
