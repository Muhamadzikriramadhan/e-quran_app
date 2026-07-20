import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../../core/widgets/google_colored_logo.dart';

import '../../../../core/theme/theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

import '../../../../core/services/supabase_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal Logout: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: IslamicBackground(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: SupabaseService.instance.getUserProfile(user),
            builder: (context, snapshot) {
              final profileData = snapshot.data;
              final name = profileData?['full_name'] ??
                  user?.userMetadata?['full_name'] ??
                  user?.userMetadata?['name'] ??
                  'Pengguna E-Quran';
              final email = profileData?['email'] ??
                  user?.email ??
                  'Tidak ada email';
              final avatarUrl = profileData?['avatar_url'] ??
                  user?.userMetadata?['avatar_url'] ??
                  user?.userMetadata?['picture'] ??
                  '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Avatar Card Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xffD4AF37),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: avatarUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: avatarUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: primaryColor,
                                        child: const Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.user,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: primaryColor,
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.user,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: greyColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 30),

                // Info Section Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        icon: FontAwesomeIcons.shieldHalved,
                        title: "Keamanan Akun",
                        subtitle: "Terverifikasi via Google OAuth 2.0",
                        iconColor: const Color(0xffD4AF37),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Logout Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.rightFromBracket,
                          size: 18,
                        ),
                        label: Text(
                          "Keluar dari Akun",
                          style: whiteTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: semiBold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    ),
  ),
);
}

  Widget _buildInfoTile({
    required dynamic icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: icon is Widget
              ? icon as Widget
              : (icon is IconData
                  ? Icon(
                      icon as IconData,
                      size: 18,
                      color: iconColor,
                    )
                  : FaIcon(
                      icon,
                      size: 18,
                      color: iconColor,
                    )),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Konfirmasi Logout",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Apakah Anda yakin ingin keluar dari akun ini?",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Batal",
                style: GoogleFonts.poppins(color: greyColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(LogoutEvent());
              },
              child: Text(
                "Keluar",
                style: whiteTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
