import "dart:math";

import 'package:flutter/material.dart';
import 'package:grp_project/screens/image_capture.dart';
import 'package:grp_project/widgets/side-drawer.dart';

class TutorialsScreen extends StatefulWidget {
  static const routeName = '/tutorial-screen';

  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  _TutorialsScreenState createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final List wordList = [
    'country',
    'million',
    'dog',
    'cat',
    'currency',
    'decade',
    'victory',
    'uncle',
    'elephant',
    'cousin',
    'nephew',
    'wealth',
    'cat',
    'bat',
    'god'
  ];

  final tutorialCall = true;

  String generatedWord = 'hello';

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  void generateRandomWord() {
    var element = getRandomElement(wordList);
    print(element);
    setState(() {
      generatedWord = element;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tutorials',
          style: TextStyle(
            fontFamily: 'Helvetica',
          ),
        ),
      ),
      drawer: SideDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: generateRandomWord,
        child: Icon(Icons.refresh),
      ),
      body: generatedWord == 'hello'
          ? Padding(
              padding: EdgeInsets.only(left: 80, bottom: 100),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      'Please click on ',
                      style: TextStyle(fontFamily: 'Helvetica'),
                    ),
                    Icon(Icons.refresh),
                    Text(' to start the tutorial'),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                heightFactor: 1,
                widthFactor: 2,
                child: Container(
                  height: 1000,
                  width: double.infinity,
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                      'Write this word and upload the image for analysis'),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  generatedWord,
                                  style: TextStyle(
                                    fontSize: 45,
                                  ),
                                ),
                                Divider(),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    height: 300,
                                    width: double.infinity - 100,
                                    child: ClipRRect(
                                      child: Image.network(
                                        'https://i.ytimg.com/vi/MPV2METPeJU/maxresdefault.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('Upload Image here'),
                                Icon(Icons.arrow_drop_down),
                                ImageCapture(tutorialCall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
