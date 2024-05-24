import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';

class ViewListBooking extends StatefulWidget {
  const ViewListBooking({Key? key}) : super(key: key);

  @override
  _ViewListBookingState createState() => _ViewListBookingState();
}

class _ViewListBookingState extends State<ViewListBooking> {
  late Future<List<Map<String, dynamic>>> _bookings;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bookings = fetchBookings();
  }

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    List<Map<String, dynamic>> bookingsList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('bookingform').get();
      for (var doc in snapshot.docs) {
        bookingsList.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
    return bookingsList;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdminBase,
      appBar: AppBar(
        backgroundColor: clrAdminPrimary,
      ),
      drawer: sidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: clrAdminPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text(
                  'List of Bookings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 35),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _bookings,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error fetching bookings'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No bookings found'));
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Booking ID')),
                              DataColumn(label: Text('User ID')),
                              DataColumn(label: Text('Facility')),
                              //DataColumn(label: Text('Date')),
                              //DataColumn(label: Text('Time')),
                            ],
                            rows: snapshot.data!.map((bookingform) {
                              return DataRow(cells: [
                                DataCell(Text(bookingform['bookingId'] ?? 'N/A')),
                                DataCell(Text(bookingform['userId'] ?? 'N/A')),
                                DataCell(Text(bookingform['game'] ?? 'N/A')),
                                //DataCell(Text(bookingform['date'] ?? 'N/A')),
                                //DataCell(Text(bookingform['time'] ?? 'N/A')),
                              ]);
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
