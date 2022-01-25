import 'package:QuakeFinder/components/bottom_button.dart';
import 'package:QuakeFinder/components/icon_content.dart';
import 'package:QuakeFinder/components/reusable_card.dart';
import 'package:QuakeFinder/components/round_icon_button.dart';
import 'package:QuakeFinder/constants.dart';
import 'package:QuakeFinder/earthquake_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String selectedSort = "time";
  int magnitude = 5;
  int displayNumber = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuakeFinder'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    setState(() {
                      selectedSort = "time";
                    });
                  },
                  colour: selectedSort == "time"
                      ? kActiveCardColour
                      : kInactiveCardColour,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.clock,
                    label: 'Order by Time',
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  onPress: () {
                    setState(() {
                      selectedSort = "magnitude";
                    });
                  },
                  colour: selectedSort == "magnitude"
                      ? kActiveCardColour
                      : kInactiveCardColour,
                  cardChild: IconContent(
                    icon: FontAwesomeIcons.exclamationTriangle,
                    label: 'Order by Magnitude',
                  ),
                ),
              ),
            ],
          )),
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Minimum Magnitude to display',
                    style: kLabelTextStyle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        magnitude.toString(),
                        style: kNumberTextStyle,
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Color(0xFF8D8E98),
                      activeTrackColor: Colors.white,
                      thumbColor: Color(0xFFEB1555),
                      overlayColor: Color(0x29EB1555),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: magnitude.toDouble(),
                      min: 1.0,
                      max: 10.0,
                      onChanged: (double newValue) {
                        setState(() {
                          magnitude = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Number of items to display',
                          style: kLabelTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          displayNumber.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(() {
                                    displayNumber--;
                                  });
                                }),
                            SizedBox(
                              width: 50.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  displayNumber++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          BottomButton(
            buttonTitle: 'Search',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EarthquakeScreen(
                    orderBy: selectedSort,
                    minMag: magnitude,
                    limit: displayNumber,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
