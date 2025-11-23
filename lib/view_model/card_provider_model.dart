import 'dart:developer';

import 'package:card_mockapi_example/model/card_res_model.dart';
import 'package:card_mockapi_example/repositories/card_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardProviderModel extends ChangeNotifier {
  final CardRepo cardRepo;
  CardProviderModel({required this.cardRepo});

  CardState cardState = CardState();

  Future setlocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      CardState.localDataPref,
      cardResModelToJson(cardState.cardData),
    );
    prefs.setInt(CardState.localpagePref, cardState.page);
  }

  getLocalLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(CardState.localpagePref)) {
      cardState.page = (prefs.getInt(CardState.localpagePref)!);
    } else {
      cardState.page;
    }
  }

  getLocalData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(CardState.localDataPref)) {
        cardState.cardData = cardResModelFromJson(
          prefs.getString(CardState.localDataPref)!,
        );
      } else {
        cardState.cardData = [];
      }
    } catch (e) {
      cardState.cardData = [];
      log('$e', name: 'ERROR AT getLocalData');
    }

    notifyListeners();
  }

  Future clearState() async {
    cardState.clearState();
    return await getCardData();
  }

  initiate() async {
    cardState.scrollController.addListener(() async {
      if (cardState.scrollController.position.atEdge) {
        bool isBottom =
            cardState.scrollController.position.pixels ==
            cardState.scrollController.position.maxScrollExtent;

        if (isBottom) {
          if (!cardState.isCardDataLoading) {
            cardState.page++;
            await getCardData();
          }
        }
      }
    });
  }

  Future getCardData() async {
    try {
      cardState.isCardDataLoading = true;
      notifyListeners();
      await cardRepo.getCardDataCall(cardState.page, cardState.limit).then((
        value,
      ) {
        if (value.statusCode == 200) {
          cardState.cardData.addAll(cardResModelFromJson(value.data));
        } else {
          cardState.cardData.clear();
        }
      });
      await setlocalData();
    } catch (e) {
      log('$e', name: 'ERROR AT getCardData');
    }
    cardState.isCardDataLoading = false;
    log('${cardState.isCardDataLoading}', name: 'getCardData');
    notifyListeners();
  }
}

class CardState {
  static const String localDataPref = "local_data_pref";
  static const String localpagePref = "local_page_pref";
  int page = 1;
  int limit = 5;
  List<CardResModel> cardData = [];
  bool isCardDataLoading = false;
  ScrollController scrollController = ScrollController();
  clearState() {
    page = 1;
    limit = 5;
    cardData.clear();
    isCardDataLoading = true;
  }
}
