import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static bool _initialized = false;

  static Future<void> init(String apiKey) async {
    if (kIsWeb) return;
    if (_initialized) return;

    await Purchases.setLogLevel(LogLevel.debug);

    await Purchases.configure(
      PurchasesConfiguration(apiKey)
        ..appUserID = null,
    );

    _initialized = true;
  }

  static Future<bool> isPro() async {
    if (kIsWeb) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('pro');
    } catch (e) {
      return false;
    }
  }

  static Future<CustomerInfo?> getCustomerInfo() async {
    if (kIsWeb) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      return null;
    }
  }

  static Future<List<Package>> getAvailablePackages() async {
    if (kIsWeb) return [];
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return [];
      return current.availablePackages;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    if (kIsWeb) return false;
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.active.containsKey('pro');
    } catch (e) {
      return false;
    }
  }

  static Future<bool> restorePurchases() async {
    if (kIsWeb) return false;
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.active.containsKey('pro');
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getSubscriptionInfo() async {
    if (kIsWeb) return null;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active['pro'];
      if (entitlement == null) return null;

      return {
        'isActive': true,
        'expirationDate': entitlement.expirationDate,
        'productIdentifier': entitlement.productIdentifier,
        'willRenew': entitlement.willRenew,
      };
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    if (kIsWeb) return;
    await Purchases.logOut();
  }
}
