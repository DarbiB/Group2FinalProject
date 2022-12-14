import 'package:dio/dio.dart';

const String lh = 'http://10.0.2.2:1200';

class BillingApi {
  final _dio = Dio(BaseOptions(baseUrl: lh));

  Future<List> getAllInvoices() async {
    final response = await _dio.get('/getAllInvoices');

    return response.data['Billing'];
  }

  Future<List> getAllInvoiceAndPet() async {
    final response = await _dio.get('/getAllInvoiceAndPet');

    return response.data['Billing'];
  }

  Future<List> getPetsOwners(String petId) async {
    final response =
        await _dio.get('/getPetsOwners', queryParameters: {"petId": petId});

    return response.data["Owners"];
  }

  Future<Map> getOwner(String ownerId) async {
    final response =
        await _dio.get('/getOwner', queryParameters: {"ownerId": ownerId});

    return response.data["Owner"];
  }

  Future<List> getOwnersPets(String ownerId) async {
    final response =
        await _dio.get('/getPetsOwners', queryParameters: {"ownerId": ownerId});

    return response.data["Pets"];
  }

  Future<List> getAllPets() async {
    final response = await _dio.get('/getAllPets');

    return response.data['Pets'];
  }

  Future<List> editOwner(String id, String fname, String lname, String address,
      String city, String state, String zip, String email, String phone) async {
    final response = await _dio.post('/editOwnerById', data: {
      'id': id,
      'ownerFName': fname,
      'ownerLName': lname,
      'ownerAddress': address,
      'ownerCity': city,
      'ownerState': state,
      'ownerZip': zip,
      'ownerEmail': email,
      'ownerPhone': phone
    });
    return response.data;
  }
}
