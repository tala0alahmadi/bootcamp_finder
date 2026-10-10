import 'package:bootcamp_finder/model/bootcamp.dart';
import 'package:bootcamp_finder/services/supabase_client.dart';

class BootcampService {
  static Future<List<Bootcamp>> getBootcamps() async {
    final rows = await SupabaseService.client.from('bootcamps').select();

    return rows.map((row) => Bootcamp.fromJson(row)).toList();
  }
}
