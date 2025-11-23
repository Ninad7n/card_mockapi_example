import 'package:card_mockapi_example/view_model/card_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'componants/bad_card_widget.dart';
import 'componants/good_card_widget.dart';
import 'componants/promo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var state = context.read<CardProviderModel>();
      await state.getLocalLimit();
      await state.getLocalData();
      if (state.cardState.cardData.isEmpty) {
        state.getCardData();
      }
      state.initiate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(
          "Home Screen",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Consumer<CardProviderModel>(
        builder: (context, provider, child) {
          if (provider.cardState.isCardDataLoading &&
              provider.cardState.cardData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              return await provider.clearState();
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    controller: provider.cardState.scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      var card = provider.cardState.cardData[index];
                      return card.type == "bad"
                          ? BadCardWidget(card: card)
                          : GoodCardWidget(card: card);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      if ((index + 1) % 3 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PromoCard(),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    itemCount: provider.cardState.cardData.length,
                  ),
                ),
                if (provider.cardState.isCardDataLoading &&
                    provider.cardState.cardData.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
