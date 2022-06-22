import 'package:cloud_firestore/cloud_firestore.dart';

class SwapData {
  // Conclude Event button
  Future<void> swapEvents(String id, Map<String, dynamic> dataToSwap) async {
    try {
      await FirebaseFirestore.instance
          .collection("upcoming_events")
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
    try {
      await FirebaseFirestore.instance
          .collection("completed_events")
          .add(dataToSwap);
    } catch (e) {
      print(e);
    }
  }
}
