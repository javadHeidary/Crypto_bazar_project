import 'package:crypto_1/constants/constant.dart';
import 'package:crypto_1/model/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.CryptoList, super.key});
  final List<Crypto>? CryptoList;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Crypto>? CryptoList;
  bool IsUpdationSearchBox = false;
  @override
  void initState() {
    super.initState();
    CryptoList = widget.CryptoList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: blackColor,
        backgroundColor: blackColor,
        title: Text(
          'کریپتو بازار',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'mrbh',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: blackColor,
      body: Scaffold(
        backgroundColor: blackColor,
        body: Column(
          children: [
            Container(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      getListCrypto(value);
                    });
                  },
                  cursorColor: greenColor,
                  showCursor: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greenColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'mrbh',
                      color: Colors.white,
                    ),
                    hintText: 'نام رمز ارز را وارد کنید',
                  ),
                ),
              ),
            ),
            Visibility(
              visible: IsUpdationSearchBox,
              child: Text(
                'لیست درحال اپدیت شدن',
                style: TextStyle(
                    fontFamily: 'mrbh', color: greenColor, fontSize: 15),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: blackColor,
                color: greenColor,
                onRefresh: () async {
                  List<Crypto> Refershing = await getData(context);
                  setState(() {
                    CryptoList = Refershing;
                  });
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: CryptoList!.length,
                        (context, index) => ListTile(
                          title: Text(
                            '${CryptoList![index].name}',
                            style: TextStyle(fontSize: 16, color: greenColor),
                          ),
                          subtitle: Text(
                            '${CryptoList![index].symbol}',
                            style: TextStyle(fontSize: 12, color: greyColor),
                          ),
                          leading: SizedBox(
                            width: 25,
                            child: Center(
                              child: Text(
                                '${CryptoList![index].rank}',
                                style:
                                    TextStyle(fontSize: 12, color: greyColor),
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${CryptoList![index].priceUsd!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 14, color: greyColor),
                                  ),
                                  Text(
                                    '${CryptoList![index].changePercent24Hr!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: getColorChangePrice(
                                          CryptoList![index].changePercent24Hr),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(10),
                              getTredingArrow(
                                  CryptoList![index].changePercent24Hr),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getColorChangePrice(changePriceTime) {
    return changePriceTime > 0 ? greenColor : redColor;
  }

  Widget getTredingArrow(changePriceTime) {
    return changePriceTime > 0
        ? Icon(
            Icons.trending_up,
            color: greenColor,
          )
        : Icon(
            Icons.trending_down,
            color: redColor,
          );
  }

  Future<List<Crypto>> getData(context) async {
    var Response = await Dio().get('https://api.coincap.io/v2/assets/');
    List<Crypto> CryptoList = Response.data['data']
        .map<Crypto>(
          (jsonObject) => Crypto.objectFromJSON(jsonObject),
        )
        .toList();

    return CryptoList;
  }

  void getListCrypto(String value) async {
    if (value.isEmpty) {
      setState(() {
        IsUpdationSearchBox = true;
      });
      List<Crypto> NewCryptoList = await getData(context);
      setState(() {
        CryptoList = NewCryptoList;

        IsUpdationSearchBox = false;
      });
      return;
    }
    List<Crypto> ListFiltterCrypto = CryptoList!
        .where((element) => element.name!.toLowerCase().contains(value))
        .toList();
    setState(() {
      CryptoList = ListFiltterCrypto;
    });
  }
}
