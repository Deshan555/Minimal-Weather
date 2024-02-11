
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/SuggestionModel.dart';

class SuggestionService{
  Future<SuggestionsModel> getOpenAIResponse(String personType, String city, String condition) async {

    print("================================================================================================= suggestion service");
    const String apiKey = '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';
    const String endpoint = 'https://api.openai.com/v1/engines/text-davinci-003/completions';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final String prompt = """
    Generate day planning suggestions based on the weather, List View
    Person Type: $personType
    City: $city
    Weather: $condition
    """;

    final Map<String, dynamic> body = {
      'prompt': prompt,
      'max_tokens': 200,
      'n': 1,
    };

    final response = await http.post(Uri.parse(endpoint), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      debugPrint('Response Body : ${response.body}');
      return SuggestionsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Can Not Get Daily Suggestions From API : ${response.body}');
    }
  }

}