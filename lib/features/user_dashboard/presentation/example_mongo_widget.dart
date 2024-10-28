import 'package:flutter/material.dart';
import 'package:landing_page/core/resources/mongo/db_services.dart';

class MongoExample extends StatefulWidget {
  const MongoExample({
    super.key,
  });

  @override
  State<MongoExample> createState() => _BasicBodyState();
}

class _BasicBodyState extends State<MongoExample> {
  late Future<List<dynamic>> items;

  @override
  void initState() {
    super.initState();
    items = ApiService.getItems();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Center(
    //     child: Text('Welcome to the User Dashboard'),
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index]['name']),
                  subtitle: Text(snapshot.data![index]['value'].toString()),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ApiService.addItem({'name': 'New Item', 'value': 100});
          setState(() {
            items = ApiService.getItems();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
