
// import 'package:get/get.dart';

// import '../../../../data/providers/base_provider.dart';

// /// Provider for Outlet API endpoints
// class OutletProvider extends BaseProvider {
//   /// Get list of active outlets
//   Future<Response> getOutlets({
//     int page = 1,
//     int perPage = 15,
//     String? search,
//     int? typeOutletId,
//   }) async {
//     final query = <String, String>{
//       'page': page.toString(),
//       'per_page': perPage.toString(),
//       if (search != null) 'search': search,
//       if (typeOutletId != null) 'type_outlet_id': typeOutletId.toString(),
//     };
//     return get('.....', query: query);
//   }