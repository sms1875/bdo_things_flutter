import 'dart:convert';

import 'package:bdo_things/data/exceptions/server_exception.dart';
import 'package:bdo_things/domain/entities/coupon.dart';
import 'package:http/http.dart' as http;

abstract class CouponRemoteDataSource {
  Future<List<Coupon>> getCoupons();
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  static const String FIRESTORE_URL = 'https://firestore.googleapis.com/v1/projects/bdothings/databases/(default)/documents';
  static const String _couponEndpoint = '/coupon';

  final http.Client client;

  CouponRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Coupon>> getCoupons() async {
    try {
      final response = await client.get(Uri.parse(FIRESTORE_URL + _couponEndpoint));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
        final couponList = (decodedData['documents'] as List)
            .map((document) => Coupon.fromMap(document['fields']))
            .toList();
        return couponList;
      } else {
        throw ServerException('Failed to load data: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw 'CouponException: $e';
    } catch (e) {
      throw ServerException('Failed to load data: $e');
    }
  }
}