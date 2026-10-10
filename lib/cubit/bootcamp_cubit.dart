import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bootcamp.dart';
import '../services/bootcamp_service.dart';
import '../services/cache_service.dart';

part 'bootcamp_state.dart';

class BootcampCubit extends Cubit<BootcampState> {
  BootcampCubit() : super(BootcampLoading());

  Future<void> loadBootcamps() async {
    emit(BootcampLoading());

    //  أول شي نقرأ النسخة المحفوظة بالجوال
    final cached = await CacheService.load();

    //  لو فيه نسخة، نعرضها فوراً بدون ما ننتظر الإنترنت
    if (cached.isNotEmpty) {
      emit(BootcampSuccess(cached));
    }

    try {
      final data = await BootcampService.getBootcamps();

      // وصلت بيانات جديدة: نحفظها للمرة الجاية
      await CacheService.save(data);

      emit(BootcampSuccess(data));
    } catch (e) {
      // لو الجلب فشل وعندنا نسخة معروضة، نخليها ونسكت.
      // نعرض الخطأ بس لو ما فيه شي نعرضه
      if (cached.isEmpty) {
        emit(BootcampError());
      }
    }
  }
}
