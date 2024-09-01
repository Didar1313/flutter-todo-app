import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userInput = TextEditingController();
  int _selectedIndex = 0;
  final List<String> _itemsList = ["Today", "Tomorrow", "OffDay"];

  final Map<String, List<bool>> _checkboxStates = {
    "Today": [],
    "Tomorrow": [],
    "OffDay": [],
  };

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF09adfe),
          title: Text(
            "TOD0 App",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF13D8CA), Color(0xFF09adfe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Hello\nDidar Bhuiyan",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _box(0, "Today"),
                    _box(1, "Tomorrow"),
                    _box(2, "OffDay"),
                  ],
                ),
              ),
              SizedBox(height: 25),
              // Corrected this part to directly use showData() without wrapping it in a Text widget.
              Expanded(
                child: showData(_itemsList[_selectedIndex]),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _floatingButton();
          },
          backgroundColor: Color(0xFF13D8CA),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _box(int a, String b) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = a;
        });
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        color: _selectedIndex == a ? Colors.blue : Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: _selectedIndex == a ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            b,
            style: TextStyle(
                fontSize: 20,
                color: _selectedIndex == a ? Colors.black : Colors.grey),
          ),
        ),
      ),
    );
  }

  _floatingButton() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add new item"),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: "Enter the task"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  sendData(_itemsList[_selectedIndex], textEditingController);
                },
                child: Text("Done")),
          ],
        );
      },
    );
  }

  Future sendData(
      String itemsList, TextEditingController textEditingController) async {
    if (textEditingController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection(itemsList).add({
        "Name": textEditingController.text,
      });
      textEditingController.clear();
      Navigator.of(context).pop();
    } else {
      print("Input is empty");
    }
  }

  Widget showData(String itemsList) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(itemsList).snapshots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Data Found"));
        } else {
          // Initialize checkbox states for this category if not already initialized
          if (_checkboxStates[itemsList]!.length != snapshot.data!.docs.length) {
            _checkboxStates[itemsList] = List<bool>.filled(snapshot.data!.docs.length, false);
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: _checkboxStates[itemsList]![index],
                    onChanged: (bool? value) {
                      setState(() {
                        _checkboxStates[itemsList]![index] = value!;
                      });
                    },
                  ),
                  title: Text(
                    data["Name"].toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }


}
