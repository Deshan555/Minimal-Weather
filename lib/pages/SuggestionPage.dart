import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../models/SuggestionModel.dart';
import '../services/SuggestionService.dart';

class SuggestionPage extends StatefulWidget {
  final String weatherCondition;
  final String city;

  const SuggestionPage({
    Key? key,
    required this.weatherCondition,
    required this.city
  }) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState(); // Corrected class name
}

class _SuggestionPageState extends State<SuggestionPage> {
  final _suggestionService = SuggestionService();
  SuggestionsModel? _suggestions;
  String lastFetchTime = '';

  _fetchSuggestions() async {
    const personType = 'Student';
    final cityName = widget.city ?? 'Colombo';
    final condition = widget.weatherCondition ?? 'ClearSky';
    try {
      final suggestions = await _suggestionService.getOpenAIResponse(
          personType, cityName, condition);
      setState(() {
        lastFetchTime = DateTime.now().toString();
        _suggestions = suggestions;
      });
    } catch (exception) {
      throw Exception('Error getting suggestions for location : $exception');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      _suggestions == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/loading.json'),
                  const SizedBox(height: 20),
                  Text(
                    'Loading suggestions...'.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 45),
                  Text(
                    'Suggestions'.toUpperCase(),
                      style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  Lottie.asset(
                    'assets/planing.json',
                    width: 300,
                    height: 300,
                  ),
                  Text(
                    'Last Updated : $lastFetchTime',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _fetchSuggestions();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 800,
                    child: SingleChildScrollView(
                        child: Text(
                      _suggestions?.suggestion ?? 'Loading...',
                      softWrap: true,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ],
              ),
            ),
    );
  }
}
