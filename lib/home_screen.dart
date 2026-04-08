import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen ({super.key});
  
    final List<String> days = const [
      'Senin','Selasa','Rabu','kamis','Jumat','Sabtu','Minggu'
    ];

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'YOUR SCHEDULE',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade800,
        ),
      ),
    ),
    body: Padding (
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        children: [
          Center(
            child: Text(
              'HARI',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade800,
                letterSpacing: 2
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print('Membuka Jadwal Hari ${days[index]}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CA4C5),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12)
                      ),
                       elevation: 0,
                    ),
                    child: Text(
                      days[index],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  
                );
              }
            ),
          ),
            
        ],
      ),
    ),
    );
  } 
}