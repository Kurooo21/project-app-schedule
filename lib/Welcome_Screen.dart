import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea memastikan UI tidak tertutup poni (notch) HP
      body: SafeArea(
        child: Center(
          // Column mirip flex-col, menyusun elemen dari atas ke bawah
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Mirip justify-center
            children: [
              // 1. Ikon Ilustrasi (Pengganti gambar sementara)
              Icon(
                Icons.calendar_month_rounded,
                size: 150,
                color: Colors.blueGrey.shade300,
              ),
              const SizedBox(height: 40), // Spasi (Margin)
              
              // 2. Teks Welcome
              Text(
                'WELCOME',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              
              // 3. Teks Sub-judul (Opsional, agar lebih manis)
              Text(
                'Daily Schedule App',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 60), // Spasi agak jauh sebelum tombol
              
              // 4. Tombol Mulai
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CA4C5), // Warna biru kalem sesuai desainmu
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bikin sudut tombol membulat modern
                  ),
                  elevation: 0, // Menghilangkan bayangan kaku bawaan tombol
                ),
                child: Text(
                  'MULAI',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}