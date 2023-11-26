import 'package:flutter/material.dart';
import 'package:santander_meal/extensions/context_styles.dart';
import 'package:santander_meal/extensions/date_time_prettifier.dart';
import 'package:santander_meal/extensions/double_currency.dart';
import 'package:santander_meal/shared/dracula_styles.dart';

class TransactionTile extends StatelessWidget {
  final double _value;
  final DateTime _date;
  final String _description;

  const TransactionTile({
    super.key,
    required double value,
    required DateTime date,
    required String description,
  })  : _value = value,
        _date = date,
        _description = description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      isThreeLine: true,
      minVerticalPadding: 10,
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      title: Text(
        _description,
        style: context.styles.text.bodyLarge,
        textAlign: TextAlign.start,
      ),
      subtitle: Text(
        _date.slashedDate,
        style: context.styles.text.bodySmall.copyWith(
          color: DraculaStyles.cyan,
        ),
      ),
      trailing: Column(
        children: [
          Text(
            _value.euro,
            style: context.styles.text.bodyLarge.copyWith(
              color: _getColorForTransaction(context),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForTransaction(BuildContext context) => _value >= 0
      ? context.styles.color.onSecondary
      : context.styles.color.error;
}
