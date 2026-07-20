import 'package:flutter_dotenv/flutter_dotenv.dart';

String get baseUrl =>
    dotenv.env['BASE_URL'] ?? "https://equran.id/api/v2/";
String get baseUrlMuslimApi =>
    dotenv.env['BASE_URL_MUSLIM_API'] ?? "https://muslim-api-three.vercel.app/v1/";

// Supabase Configuration
String get supabaseUrl =>
    dotenv.env['SUPABASE_URL'] ?? "https://nolblkkwmkufwcivskgb.supabase.co";
String get supabaseAnonKey =>
    dotenv.env['SUPABASE_ANON_KEY'] ?? "";

// Google OAuth Configuration
String get googleWebClientId =>
    dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? "";
String get googleIosClientId =>
    dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? "";
