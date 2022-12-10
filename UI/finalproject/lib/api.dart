import 'package:dio/dio.dart';

const String lh = 'http://10.0.2.2:1200';

class BillingApi {
  final _dio = Dio(BaseOptions(baseUrl: lh));

  Future<List> getAllInvoices() async {
    final response = await _dio.get('/getAllInvoices');

    return response.data['Billing'];
  }

  Future<List> getPetsOwners() async {
    final response = await _dio.get('/getPetsOwners');

    return response.data['Owners'];
  }

  Future<List> getAllPets() async {
    final response = await _dio.get('/getAllPets');

    return response.data['Pets'];
  }
}
