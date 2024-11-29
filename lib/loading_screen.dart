import 'package:crypto_1/constants/constant.dart';
import 'package:crypto_1/home_screen.dart';
import 'package:crypto_1/model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor.withOpacity(0.4),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo.png'),
            SpinKitWave(
              color: Colors.white,
              size: 40,
            )
          ],
        ),
      ),
    );
  }

  Future<void> getData(context) async {
    var Response = await Dio().get('https://api.coincap.io/v2/assets/');
    List<Crypto> CryptoList = Response.data['data']
        .map<Crypto>(
          (jsonObject) => Crypto.objectFromJSON(jsonObject),
        )
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return HomeScreen(
            CryptoList: CryptoList,
          );
        },
      ),
    );
  }
}
