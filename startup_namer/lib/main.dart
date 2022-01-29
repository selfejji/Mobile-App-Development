/*------------------------------------
  Sammy Elfejji

  CSC 4360 - Umoja

  Jan 27, 2022

  Homework #1
-------------------------------------*/

import 'package:english_words/english_words.dart'; // imports english words library
import 'package:flutter/material.dart'; // imports nescessary library for flutter app

void main() { // runs the app outside of the class method
  runApp(const MyApp());
}

/*-------------------------------------
  This is the parent application class

  The purpose of this class is to define 
  all of the application widgets

  This application will infinitely 
  generate random combonations of english
  words to be used as a start up company
  name idea
--------------------------------------*/
class MyApp extends StatelessWidget {                       
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

/*-------------------------------------------
  This is the RandomWords class

  The purpose of this class is to create a 
  stateful widget of the RandomWords class
  in order to update the randomly generated
  english words
--------------------------------------------*/

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

/*-------------------------------------------
  This is the RandomWordsState class

  The purpose of this class is to build the
  stateful widget via the BuildContext class
  and create a random word pair
--------------------------------------------*/

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // this allows us to save the word pairs in a generic WordPair list                 
  final _biggerFont = const TextStyle(fontSize: 18);

  /*----------------------------------
   The function build is implemented to 
   genereate the random word pairs as
   a stateful widget. Instead of taking
   our word pairs directly from the 
   library, we can pull from _suggestions 
  -----------------------------------*/

  @override
  Widget build(BuildContext context) {
    return Scaffold ( // scaffold is what implements the basic visual design                 
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );                                      
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),

      /*-------------------------------------------------------
       The itemBuilder callback is called once per suggested
       word pairing, and places each suggestion into a ListTile
       row. For even rows, the function adds a ListTile row for
       the word pairing. For odd rows, the function adds a
       Divider widget to visually separate the entries. Note that
       the divider may be difficult to see on smaller devices.
      ---------------------------------------------------------*/

      itemBuilder: (context, i) {
        if (i.isOdd) { 
         return const Divider(); // Add a one-pixel-high divider widget before each row
        }

        /*--------------------------------------------------
         For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
         this calculates the actual number of word pairings
         in the ListView, minus the divider widgets.
        ---------------------------------------------------*/

        final index = i ~/ 2; // The syntax "i ~/ 2" divides i by 2 and returns an integer

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); // generates 10 more and add them to the suggestions list
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  /*-----------------------------------
   This widget builds th rows we display
   the word pairs on everytime a new pair
   is generated and displays it in a
   ListTile
  -----------------------------------*/

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
