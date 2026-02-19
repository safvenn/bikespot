import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikespot/add_bike.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bikes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bikes found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var bikeData = snapshot.data!.docs[index];
              return Card(
                elevation: 10,
                child: Column(
                  children: [
                    if (bikeData['image'] != null)
                      Image.network(bikeData['image']),
                    Text(bikeData['name'] ?? 'No Name'),
                    Text(bikeData['price'] ?? 'No Price'),
                    Text(bikeData['No.plate'] ?? 'No Plate'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBikePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
