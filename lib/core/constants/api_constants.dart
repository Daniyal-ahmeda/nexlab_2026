class ApiConstants {
  // Cloudflare Tunnel URL
  static const String cloudflareTunnelUrl = 'https://coupled-larger-desert-absent.trycloudflare.com/api';

  static String get baseUrl {
    // Cloudflare Tunnel allows physical devices and emulators to connect from anywhere
    return cloudflareTunnelUrl;

    // Uncomment below if switching back to local network:
    // if (kIsWeb) {
    //   return 'http://localhost:8000/api';
    // }
    // return 'http://192.168.0.106:8000/api';
  }
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String me = '/me';
  static const String tests = '/tests';
  static const String labs = '/labs';
  static const String bookings = '/bookings';
  static const String results = '/results';
  static const String familyMembers = '/family-members';
  static const String paymentMethods = '/payment-methods';
}
