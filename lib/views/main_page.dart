import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:santander_meal/extensions/context_styles.dart';
import 'package:santander_meal/extensions/string_card_info.dart';
import 'package:santander_meal/providers/santander_api.dart';
import 'package:santander_meal/shared/shared_preferences_repository.dart';
import 'package:santander_meal/widgets/credit_card.dart';
import 'package:santander_meal/widgets/transaction_tile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _cardNumber = "XXXX XXXX XXXX XXXX";
  double _netBalance = 0.0;
  double _grossBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _handleWidgetData();
  }

  Future _handleWidgetData() async {
    if (!await _isCardInformationStored()) {
      return;
    }

    await _getCachedCardData();
    await _updateCardData();
  }

  Future<bool> _isCardInformationStored() async {
    final cardNumber = await SharedPreferencesRepository.getCardNumber();
    final cardSecret = await SharedPreferencesRepository.getCardSecret();

    return cardNumber.length == 16 && cardSecret.length == 3;
  }

  final _cardNumberController = TextEditingController();
  final _cardSecretController = TextEditingController();

  AlertDialog _cardInformationDialog() => AlertDialog.adaptive(
        title: const Text("Welcome!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Card Number"),
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                CreditCardNumberInputFormatter(),
              ],
            ),
            TextField(
              decoration: const InputDecoration(hintText: "CVV"),
              controller: _cardSecretController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                CreditCardCvcInputFormatter(isAmericanExpress: false)
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("CONFIRM"),
            onPressed: () {
              final spaceRegex = RegExp(r"\s");

              final cardNumber =
                  _cardNumberController.text.replaceAll(spaceRegex, "");
              final cardSecret =
                  _cardSecretController.text.replaceAll(spaceRegex, "");

              if (cardNumber.isInvalidCardNumber ||
                  cardSecret.isInvalidCardSecret) {
                return;
              }

              SharedPreferencesRepository.setCardNumber(cardNumber);
              SharedPreferencesRepository.setCardSecret(cardSecret);
              Navigator.pop(context, true);
            },
          )
        ],
      );

  Future _getCachedCardData() async {
    final cachedCardReference =
        await SharedPreferencesRepository.getLastCardReference();
    final cachedNetBalance =
        await SharedPreferencesRepository.getLastNetBalance();
    final cachedGrossBalance =
        await SharedPreferencesRepository.getLastGrossBalance();

    if (cachedCardReference.isEmpty ||
        cachedNetBalance.isNaN ||
        cachedGrossBalance.isNaN) {
      debugPrint("porra");
      return;
    }

    setState(() {
      _cardNumber = cachedCardReference;
      _netBalance = cachedNetBalance;
      _grossBalance = cachedGrossBalance;
    });
  }

  Future _updateCardData() async {
    final api = SantanderApi();
    await api.login();

    final details = await api.getAccountDetails();

    await SharedPreferencesRepository.setLastCardReference(details["cardRef"]);
    await SharedPreferencesRepository.setLastNetBalance(details["netBalance"]);
    await SharedPreferencesRepository.setLastGrossBalance(
        details["grossBalance"]);

    setState(() {
      _cardNumber = details["cardRef"];
      _netBalance = details["netBalance"];
      _grossBalance = details["grossBalance"];
    });
  }

  Future _onRefresh() async => await _updateCardData();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (!await _isCardInformationStored() && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => _cardInformationDialog(),
        ).then((_) => _updateCardData());
      }
    });

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: CreditCard(
                    cardNumber: _cardNumber,
                    netBalance: _netBalance,
                    grossBalance: _grossBalance,
                  ),
                ),
              ),
              Divider(
                color: context.styles.color.onPrimary,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 0,
                  separatorBuilder: (context, index) => Divider(
                    indent: 5,
                    endIndent: 5,
                    color: context.styles.color.outline,
                  ),
                  itemBuilder: (context, index) {
                    return TransactionTile(
                      value: 0,
                      date: DateTime.now(),
                      description: "",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
