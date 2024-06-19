import 'package:flutter/material.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingService {
  final CollectionReference _bookingsCollection = FirebaseFirestore.instance.collection('bookingform');

  Future<void> addBooking({
    required String userId,
    required String game,
    required int players,
    required String date,
    required String court,
    required String time,
    String status = 'Confirmed',
  }) async {
    try {
      bool isAvailable = await checkCourtAvailability(date, court, time);
      if (!isAvailable) {
        throw Exception('Court is not available at the selected date and time.');
      }

      // Generate the booking ID
      int bookingCount = await _getBookingCount();
      String bookingId = 'B${bookingCount.toString().padLeft(2, '0')}';

      DocumentReference bookingRef = _bookingsCollection.doc(bookingId);
      await bookingRef.set({
        'bookingId': bookingId,
        'userId': userId, // Store the user's display name or email
        'game': game,
        'players': players,
        'date': date,
        'court': court,
        'time': time,
        'createdAt': Timestamp.now(),
        'status': status,
      });

      print("Booking added successfully with ID: $bookingId");
    } catch (error) {
      print("Failed to add booking: $error");
      throw error;
    }
  }

  Future<int> _getBookingCount() async {
    QuerySnapshot snapshot = await _bookingsCollection.get();
    return snapshot.docs.length + 1;
  }

  Future<bool> checkCourtAvailability(String date, String court, String time) async {
    try {
      QuerySnapshot snapshot = await _bookingsCollection
          .where('date', isEqualTo: date)
          .where('court', isEqualTo: court)
          .where('time', isEqualTo: time)
          .get();

      return snapshot.docs.isEmpty;
    } catch (error) {
      print("Failed to check court availability: $error");
      throw error;
    }
  }

  Future<List<String>> getAvailableTimeSlots(String date, String court) async {
    List<String> allTimeSlots = [
      '9:00 AM - 10:00 AM',
      '10:00 AM - 11:00 AM',
      '11:00 AM - 12:00 PM',
      '12:00 PM - 1:00 PM',
      '1:00 PM - 2:00 PM',
      '2:00 PM - 3:00 PM',
      '3:00 PM - 4:00 PM',
      '4:00 PM - 5:00 PM',
      '5:00 PM - 6:00 PM',
      '6:00 PM - 7:00 PM',
      '7:00 PM - 8:00 PM',
      '8:00 PM - 9:00 PM',
      '9:00 PM - 10:00 PM',
    ];

    QuerySnapshot snapshot = await _bookingsCollection
        .where('date', isEqualTo: date)
        .where('court', isEqualTo: court)
        .get();

    List<String> bookedTimeSlots = snapshot.docs.map((doc) => doc['time'] as String).toList();

    List<String> availableTimeSlots = allTimeSlots.where((timeSlot) => !bookedTimeSlots.contains(timeSlot)).toList();

    return availableTimeSlots;
  }
}

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({Key? key}) : super(key: key);

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
        backgroundColor: clrUserPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying booking conditions
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Conditions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. A minimum of 4 people and a maximum of 6 people per booking.\n'
                      '2. Only UTM students and staff are allowed to make reservations and use the facilities at the sports complex.\n'
                      '3. For event, please contact 07-5535776 (Mr. Sharul).\n',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Button to navigate to the next page of the booking form
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingFormPage2()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1, onItemTapped: (_) {}),
    );
  }
}

// ============================ BOOKING PAGE 2 =============================

class BookingFormPage2 extends StatefulWidget {
  const BookingFormPage2({Key? key}) : super(key: key);

  @override
  State<BookingFormPage2> createState() => _BookingFormPage2State();
}

class _BookingFormPage2State extends State<BookingFormPage2> {
  int _page = 0;
  String _selectedGame = 'Squash';
  int _selectedPlayers = 1;
  DateTime _selectedDate = DateTime.now();
  String _selectedCourt = 'Court 1';
  String _selectedTime = '7:00 AM - 8:00 AM'; // Default selected time slot
  String _status = 'Confirmed';

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _availableTimeSlots = [];

  late String _userId;
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _retrieveUserId();
    _fetchAvailableTimeSlots(); // Initial fetch
  }

  void _retrieveUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.email ?? '';
      });
    }
  }

  Future<void> _fetchAvailableTimeSlots() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<String> availableTimeSlots = await _bookingService.getAvailableTimeSlots(formattedDate, _selectedCourt);

    setState(() {
      _availableTimeSlots = availableTimeSlots;
      if (_availableTimeSlots.isNotEmpty && !_availableTimeSlots.contains(_selectedTime)) {
        _selectedTime = _availableTimeSlots.first;
      }
    });
  }

  void _addBookingToFirestore() {
    final bookingService = BookingService();
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    bookingService.addBooking(
      userId: _userId,
      game: _selectedGame,
      players: _selectedPlayers,
      date: formattedDate,
      court: _selectedCourt,
      time: _selectedTime,
      status: _status,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        title: Text('Booking Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Court Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text('Game:'),
            DropdownButton<String>(
              value: _selectedGame,
              onChanged: (newValue) {
                setState(() {
                  _selectedGame = newValue!;
                });
              },
              items: <String>['Squash', 'Badminton', 'Ping Pong']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('How many players:'),
            DropdownButton<int>(
              value: _selectedPlayers,
              onChanged: (newValue) {
                setState(() {
                  _selectedPlayers = newValue!;
                });
              },
              items: List<int>.generate(6, (index) => index + 1)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Select date:'),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedDate = selectedDay;
                });
                _fetchAvailableTimeSlots(); // Fetch available time slots when the date changes
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            SizedBox(height: 20),
            Text('Court:'),
            DropdownButton<String>(
              value: _selectedCourt,
              onChanged: (newValue) {
                setState(() {
                  _selectedCourt = newValue!;
                });
                _fetchAvailableTimeSlots(); // Fetch available time slots when the court changes
              },
              items: <String>['Court 1', 'Court 2', 'Court 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Select time:'),
            DropdownButton<String>(
              value: _selectedTime,
              onChanged: (newValue) {
                setState(() {
                  _selectedTime = newValue!;
                });
              },
              items: _availableTimeSlots
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addBookingToFirestore();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BookingFormPage3()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedIndex: 1, onItemTapped: (_) {}),
    );
  }
}

Future<Map<String, dynamic>> createPaymentIntent(String userId) async {
  final response = await http.post(
    Uri.parse(
        'https://us-central1-byteburst-d14d3.cloudfunctions.net/createPaymentIntent'), // Replace with your Cloud Function URL
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': userId}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Error creating payment intent: ${response.body}');
    throw Exception('Failed to create payment intent');
  }
}

class BookingFormPage3 extends StatefulWidget {
  const BookingFormPage3({Key? key}) : super(key: key);

  @override
  State<BookingFormPage3> createState() => _BookingFormPage3State();
}

class _BookingFormPage3State extends State<BookingFormPage3> {
  int _page = 0;
  bool _acknowledged = false;
  bool _agreedToPay = false;

  Future<void> initPaymentSheet(BuildContext context,
      {required String userId}) async {
    try {
      // Call your Firebase Cloud Function to create a payment intent
      final paymentData = await createPaymentIntent(userId);

      // Initialize the payment sheet
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentData['paymentIntent'],
          merchantDisplayName: 'Booking Form',
          style: ThemeMode.light,
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment completed!')),
      );

      // Navigate to the next step after payment is completed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingFormPage4()),
      );
    } catch (e) {
      if (e is stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        title: Text('Booking Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acknowledgement:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            // Card for acknowledgment
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _acknowledged,
                          onChanged: (value) {
                            setState(() {
                              _acknowledged = value!;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            'I acknowledge that the use of these sports facilities is at my own risk and I am solely responsible for myself. I will not blame the University Sports Excellence Center for any injuries, accidents, or deaths that occur to me before, during, or after the use of these sports facilities.',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10, // Adjust maxLines as needed
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToPay,
                          onChanged: (value) {
                            setState(() {
                              _agreedToPay = value!;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            'I agree to pay RM5 to use the facilities.',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10, // Adjust maxLines as needed
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Button to proceed if both acknowledged and agreed to pay
            ElevatedButton(
              onPressed: (_acknowledged && _agreedToPay)
                  ? () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        String userId = user.uid; // Get the current user's ID
                        await initPaymentSheet(context, userId: userId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User not logged in')),
                        );
                      }
                    }
                  : null, // Disable button if not acknowledged and agreed to pay
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedIndex: 1, onItemTapped: (_) {}),
    );
  }
}

class BookingFormPage4 extends StatelessWidget {
  const BookingFormPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        title: Text('Booking Confirmed'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Your booking has been confirmed!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Thank you for booking with us. Enjoy your game!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the home or main page
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BookingFormPage(),
  ));
}
