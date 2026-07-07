import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PayPerExportService {

  static Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return false;

      // Check if any package exists
      return current.availablePackages.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<Package?> getPayPerExportPackage() async {
    if (kIsWeb) return null;
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return null;

      // Find the pay-per-export package
      for (final package in current.availablePackages) {
        if (package.identifier.contains('pay_per_export') ||
            package.identifier.contains('single_export')) {
          return package;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> purchaseExport() async {
    if (kIsWeb) return false;
    try {
      final package = await getPayPerExportPackage();
      if (package == null) return false;

      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.active.containsKey('pay_per_export');
    } catch (e) {
      return false;
    }
  }

  static Future<int> getRemainingExports() async {
    if (kIsWeb) return 0;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active['pay_per_export'];
      if (entitlement == null) return 0;

      return 1; // Placeholder
    } catch (e) {
      return 0;
    }
  }

  static Future<void> consumeExport() async {
    // Track usage via server
  }
}
