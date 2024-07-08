import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:dribble_finance_app_design/service/service_helper.dart';

class PersonService{

  Future<List<Person>> fetchPersons() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    List<dynamic> body = json.decode(response.body);
    List<Person> persons = body.map((dynamic item) => Person.fromJson(item)).toList();
    return persons;
  
}

Future<dynamic> getItemStatus() async{
  String endPoint = "/api/lookup/getPropertyItemStatuses";
  var data = await ApiBaseHelper.instance.get(endPoint);
  return data;
}
}