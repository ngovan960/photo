import 'package:purchases_flutter/purchases_flutter.dart';

class PayPerExportService {
  static const String _payPerExportId = 'photo_id_pay_per_export';

  // Check if pay-per-export is available
  static Future<bool> isAvailable() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return false;

      final payPerExport = current.getPackageWithIdentifier(_payPerExportId);
      return payPerExport != null;
    } catch (e) {
      return false;
    }
  }

  // Get pay-per-export package
  static Future<Package?> getPayPerExportPackage() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return null;

      return current.getPackageWithIdentifier(_payPerExportId);
    } catch (e) {
      return null;
    }
  }

  // Purchase single export
  static Future<bool> purchaseExport() async {
    try {
      final package = await getPayPerExportPackage();
      if (package == null) return false;

      final result = await Purchases.purchasePackage(package);
      return result.entitlements.active.containsKey('pay_per_export');
    } catch (e) {
      return false;
    }
  }

  // Check remaining exports
  static Future<int> getRemainingExports() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active['pay_per_export'];
      if (entitlement == null) return 0;

      // In production, check usage from server
      return 1; // Placeholder
    } catch (e) {
      return 0;
    }
  }

  // Consume an export
  static Future<void> consumeExport() async {
    // In production, track usage via server
  }
}
