import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_calculator/main.dart';
import 'buttons_fun.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttons
            Wrap(
              children: But.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: (value == But.n0)
                            ? (sizeScreen.width / 2)
                            : (sizeScreen.width / 4),
                        height: sizeScreen.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

// button design , placement and on tap method :-
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
          color: buttonColors(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(100),
          ),
          child: InkWell(
              onTap: () => onButtonTap(value),
              child: Center(
                  child: Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              )))),
    );
  }

// different colours on button :-
  Color buttonColors(value) {
    return [But.del, But.clr].contains(value)
        ? Colors.blueGrey
        : [
            But.add,
            But.per,
            But.multiply,
            But.divide,
            But.subtract,
            But.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

// what will happen when we tap method :-
  void onButtonTap(value) {
    if (value == But.del) {
      delete();
      return;
    }
    if (value == But.clr) {
      allDelete();
      return;
    }
    if (value == But.per) {
      percentageCal();
      return;
    }
    if (value == But.calculate) {
      calculateValue();
      return;
    }
    assignValue(value);
  }

// delete element for equation :-
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

// delete all element for equation :-
  void allDelete() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

// percentage calculate :-
  void percentageCal() {
    if (number1.isNotEmpty && number2.isNotEmpty && operand.isNotEmpty) {
      calculateValue();
    }
    if (operand.isNotEmpty) {}
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

// equal button method
  void calculateValue() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case But.add:
        result = num1 + num2;
        break;
      case But.subtract:
        result = num1 - num2;
        break;
      case But.divide:
        result = num1 / num2;
        break;
      case But.multiply:
        result = num1 * num2;
        break;
      default:
        result = 0.0;
    }
    setState(() {
      number1 = "$result";
      // remove extra point like 9.00
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

// assign value to number 1 , number 2 and operand :-
  void assignValue(String value) {
    if (value != But.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculateValue();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == But.dot && number1.contains(But.dot)) return;
      if (value == But.dot && (number1.isEmpty || number1 == But.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == But.dot && number2.contains(But.dot)) return;
      if (value == But.dot && (number2.isEmpty || number2 == But.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }
}
