class SuggestionsModel {
  final String suggestion;

  SuggestionsModel({
    required this.suggestion,
  });

  factory SuggestionsModel.fromJson(Map<String, dynamic> json) {
    //print('SuggestionsModel.fromJson : $json');
    return SuggestionsModel(
      suggestion: json['choices'][0]['text'],
      //suggestion: "1. Take a Walk in Central Park - Take advantage of the sunny day and explore your city!\n\n2. Visit a Museum – Enjoy one of New York's many museums.\n\n3. Have a Picnic in the Park – Pack a picnic and enjoy the sunshine and fresh air.\n\n4. Go to the Beach – Soak up the sun at one of New York's beaches.\n\n5. Go Shopping – Browse the stores and pick up some new items to spice up your wardrobe.\n\n6. Catch a Movie – Enjoy a film in the comfort of an air conditioned movie theatre.\n\n7. Go to an Outdoor Festival – Check out an outdoor music festival or street fair.\n\n8. Have a BBQ – Fire up the grill and enjoy some BBQ in the sunshine. \n9. Take a Yoga Class – Relax and practice some yoga outside in the sunshine.\n10. Explore Your Neighbourhood – Take a walk around your neighbourhood and explore the local area."
    );
  }
}