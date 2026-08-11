import 'dart:ui';
import 'package:flutter/material.dart';

String formatCurrency(double amount, String currencyCode, [BuildContext? context]) {
  final isArabic = context != null
      ? Localizations.localeOf(context).languageCode == 'ar'
      : PlatformDispatcher.instance.locale.languageCode == 'ar';
  final amountStr = amount.toStringAsFixed(2);
  
  if (isArabic) {
    String localizedCurrency = currencyCode;
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        localizedCurrency = 'دولار أمريكي';
        break;
      case 'EUR':
        localizedCurrency = 'يورو';
        break;
      case 'GBP':
        localizedCurrency = 'جنيه إسترليني';
        break;
      case 'SAR':
        localizedCurrency = 'ريال سعودي';
        break;
      case 'AED':
        localizedCurrency = 'درهم إماراتي';
        break;
      case 'EGP':
        localizedCurrency = 'جنيه مصري';
        break;
      case 'KWD':
        localizedCurrency = 'دينار كويتي';
        break;
      case 'QAR':
        localizedCurrency = 'ريال قطري';
        break;
      case 'BHD':
        localizedCurrency = 'دينار بحريني';
        break;
      case 'OMR':
        localizedCurrency = 'ريال عماني';
        break;
      case 'JPY':
        localizedCurrency = 'ين ياباني';
        break;
    }
    return '$amountStr $localizedCurrency';
  } else {
    return '$currencyCode $amountStr';
  }
}
