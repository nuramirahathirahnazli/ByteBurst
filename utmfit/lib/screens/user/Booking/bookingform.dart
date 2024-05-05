import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/profile/profile_user.dart';
import 'package:utmfit/src/common_widgets/bottom_navigation_bar.dart';
import 'package:utmfit/src/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _page,
        onItemTapped: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
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

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // List of available time slots
  List<String> _timeSlots = [
    '7:00 AM - 8:00 AM',
    '8:00 AM - 9:00 AM',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrUserPrimary,
        title: Text('Court Information'),
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
            // Dropdown menu to select the game
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
            // Dropdown menu to select the number of players
            DropdownButton<int>(
              value: _selectedPlayers,
              onChanged: (newValue) {
                setState(() {
                  _selectedPlayers = newValue!;
                });
              },
              items: <int>[1, 2, 3, 4, 5, 6]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Select date:'),
            // Calendar to select the date
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
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            SizedBox(height: 20),
            Text('Court:'),
            // Dropdown menu to select the court
            DropdownButton<String>(
              value: _selectedCourt,
              onChanged: (newValue) {
                setState(() {
                  _selectedCourt = newValue!;
                });
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
            // Dropdown menu to select the time slot
            DropdownButton<String>(
              value: _selectedTime,
              onChanged: (newValue) {
                setState(() {
                  _selectedTime = newValue!;
                });
              },
              items: _timeSlots
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
                // Navigate to the next page of the booking form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingFormPage3()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _page,
        onItemTapped: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}

// ============================ BOOKING PAGE 3 =============================

class BookingFormPage3 extends StatefulWidget {
  const BookingFormPage3({Key? key}) : super(key: key);

  @override
  State<BookingFormPage3> createState() => _BookingFormPage3State();
}

class _BookingFormPage3State extends State<BookingFormPage3> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('This is the 3RD PAGE'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BookingFormPage(),
  ));
}
