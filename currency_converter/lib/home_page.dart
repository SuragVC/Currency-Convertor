import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController convertionFieldController = TextEditingController();
  TextEditingController convertionFieldRateController = TextEditingController();
  double result = 0;
  var spacer = const SizedBox(
    height: 10,
  );
  double? convertValue;

  updateSharedPref() async {
    String rate = convertionFieldRateController.text;
    if (rate.isEmpty) {
      return;
    }
    convertValue = double.parse(rate);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('convertValue', convertValue!);
    convertionFieldRateController.text = "";
  }

  void convert() async {
    String rate = convertionFieldController.text;
    if (rate.isEmpty) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    convertValue = prefs.getDouble('convertValue');
    result = double.parse(rate) * (convertValue ?? 82);
    setState(() {});
  }

  void reset() {
    convertionFieldController.text = "";
    result = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Currency Converter",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ColoredBox(
        color: Colors.blueGrey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _conversionText(),
              spacer,
              _ammountTextField(),
              spacer,
              _conversionButtons(),
              spacer,
              _conversionRateUpdateField()
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey,
    );
  }

  _conversionText() {
    return Text(
      'INR ${result.toStringAsFixed(2)}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 55,
        color: Colors.white,
      ),
    );
  }

  _ammountTextField() {
    var border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide.none,
      gapPadding: 10,
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        style: const TextStyle(color: Colors.black, fontSize: 20),
        controller: convertionFieldController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: "Enter Amount",
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(
            Icons.monetization_on_outlined,
            color: Colors.black,
          ),
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }

  _conversionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: convert,
          style: ElevatedButton.styleFrom(),
          child: const Text("Convert"),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: reset,
          style: ElevatedButton.styleFrom(),
          child: const Text("Reset"),
        )
      ],
    );
  }

  _conversionRateUpdateField() {
    const customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide(
        color: Colors.grey, // Define your border color here
        width: 1.0, // Define your border width here
      ),
      gapPadding: 8, // Define your gap padding here
    );

    var customDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      filled: true,
      fillColor: Colors.grey[200], // Define your fill color here
      hintText: 'Enter conversion rate',
      hintStyle: const TextStyle(
        color: Colors.grey, // Define your hint text color here
      ),
      border: customBorder,
      enabledBorder: customBorder,
      focusedBorder: customBorder.copyWith(
        borderSide: const BorderSide(
          color: Colors.blue, // Define your focused border color here
        ),
      ),
      errorBorder: customBorder.copyWith(
        borderSide: const BorderSide(
          color: Colors.red, // Define your error border color here
        ),
      ),
      focusedErrorBorder: customBorder.copyWith(
        borderSide: const BorderSide(
          color: Colors.red, // Define your focused error border color here
        ),
      ),
      prefixIcon: const Icon(
        Icons.money_sharp, // Define your prefix icon here
        color: Colors.grey, // Define your prefix icon color here
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: convertionFieldRateController,
              decoration: customDecoration,
            ),
          ),
          Expanded(flex: 1, child: spacer),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: updateSharedPref,
              style: ElevatedButton.styleFrom(),
              child: const Text("Set"),
            ),
          )
        ],
      ),
    );
  }
}
