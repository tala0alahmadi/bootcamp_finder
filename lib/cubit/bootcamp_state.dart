part of 'bootcamp_cubit.dart';

abstract class BootcampState {}

class BootcampLoading extends BootcampState {}

class BootcampSuccess extends BootcampState {
  final List<Bootcamp> bootcamps;
  BootcampSuccess(this.bootcamps);
}

class BootcampError extends BootcampState {}
