import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:utmfit/src/common_widgets/sidebar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:utmfit/src/common_widgets/admin_bottom_navigation.dart'; // Import the new widget

class ViewListBooking extends StatefulWidget {
  const ViewListBooking({Key? key}) : super(key: key);

  @override
  _ViewListBookingState createState() => _ViewListBookingState();
}

class _ViewListBookingState extends State<ViewListBooking> {
  late Future<List<Map<String, dynamic>>> _bookings;
  late Future<int> _totalBookings;
  int _selectedIndex = 2;
  int _currentPage = 0;
  final int _itemsPerPage = 7;

  @override
  void initState() {
    super.initState();
    _bookings = fetchBookings();
    _totalBookings = fetchTotalBookings();
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

  Future<int> fetchTotalBookings() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('bookingform').get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error fetching total bookings: $e");
      return 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the selected screen
    navigateToScreen(context, index);
  }

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> bookingDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Booking ID: ${bookingDetails['bookingId'] ?? 'N/A'}'),
                Text('Court: ${bookingDetails['court'] ?? 'N/A'}'),
                Text('Date: ${formatDate(bookingDetails['date'] ?? 'N/A')}'),
                Text('Game: ${bookingDetails['game'] ?? 'N/A'}'),
                Text('Players: ${bookingDetails['players'] ?? 'N/A'}'),
                Text('Status: ${bookingDetails['status'] ?? 'N/A'}'),
                Text('Time: ${bookingDetails['time'] ?? 'N/A'}'),
                Text('User ID: ${bookingDetails['userId'] ?? 'N/A'}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
  }

  void _previousPage() {
    setState(() {
      _currentPage--;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrAdminBase,
      appBar: AppBar(
        backgroundColor: clrAdminPrimary,
        elevation: 0,
        title: Row(
          children: [
            Spacer(),
            Text('Hi, Admin', style: TextStyle(color: Colors.white)),
            Spacer(),
            TextButton(
              onPressed: () {
                // Add sign out functionality here
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      drawer: sidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'List of Booking',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _totalBookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching total bookings'));
                } else {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Total All: ${snapshot.data}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
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
                    int startIndex = _currentPage * _itemsPerPage;
                    int endIndex = startIndex + _itemsPerPage;
                    List<Map<String, dynamic>> paginatedBookings = snapshot.data!.sublist(
                      startIndex,
                      endIndex > snapshot.data!.length ? snapshot.data!.length : endIndex,
                    );
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('No.')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: paginatedBookings.asMap().entries.map((entry) {
                                int index = entry.key;
                                Map<String, dynamic> booking = entry.value;
                                return DataRow(cells: [
                                  DataCell(Text((startIndex + index + 1).toString())),
                                  DataCell(Text(booking['userId'] ?? 'N/A')),
                                  DataCell(Text(formatDate(booking['date'] ?? 'N/A'))),
                                  DataCell(Text(booking['game'] ?? 'N/A')),
                                  DataCell(Text(
                                    booking['status'] ?? 'N/A',
                                    style: TextStyle(
                                      color: _getStatusColor(booking['status'] ?? ''),
                                    ),
                                  )),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.visibility),
                                      color: Colors.blue,
                                      onPressed: () {
                                        _showBookingDetails(context, booking);
                                      },
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _currentPage > 0 ? _previousPage : null,
                              child: Text('Previous'),
                            ),
                            Text('Page ${_currentPage + 1}'),
                            TextButton(
                              onPressed: endIndex < snapshot.data!.length ? _nextPage : null,
                              child: Text('Next'),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
