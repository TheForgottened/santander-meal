import 'package:flutter/material.dart';
import 'package:santander_meal/extensions/context_styles.dart';

class CreditCard extends StatelessWidget {
  static const double _padding = 15;
  static const double _aspectRatio = 1.586;
  static const double _cornerRadiusRatio = 27;

  final String _cardNumber;
  final double _netBalance;
  final double _grossBalance;

  const CreditCard({
    super.key,
    required String cardNumber,
    required double netBalance,
    required double grossBalance,
  })  : _grossBalance = grossBalance,
        _netBalance = netBalance,
        _cardNumber = cardNumber;

  @override
  Widget build(BuildContext context) {
    final cornerRadius = _getCornerRadius(context);

    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.styles.color.outline),
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          color: context.styles.color.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "€$_netBalance",
                style: context.styles.text.displayMedium.copyWith(
                  color: context.styles.color.onSecondary,
                ),
              ),
              Text(
                "Gross balance is €$_grossBalance",
                style: context.styles.text.bodySmall.copyWith(
                  color: context.styles.color.onPrimary,
                ),
              ),
              const Spacer(),
              Text(
                "CARD NUMBER",
                style: context.styles.text.bodyMedium.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(_cardNumber),
            ],
          ),
        ),
      ),
    );
  }

  double _getCornerRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / _cornerRadiusRatio;
  }
}
