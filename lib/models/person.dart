import 'dart:convert';
import 'package:http/http.dart' as http;

class Person {
  final String name;
  final double amount;

  Person({required this.name, required this.amount});

  factory Person.fromJson(Map<String, dynamic> json) {
    // Fake API'den gelen verilerde amount alanı olmadığı için rastgele bir amount değeri oluşturuyoruz
    return Person(
      name: json['name'],
      amount: ((json['id'] * 100).toDouble() * (json['id'] % 2 == 0 ? 1 : -1)),
    );
  }

  String? get imageUrl => null;
}

Future<List<Person>> fetchPersons() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Person> persons = body.map((dynamic item) => Person.fromJson(item)).toList();
    return persons;
  } else {
    throw Exception('Failed to load persons');
  }
}
