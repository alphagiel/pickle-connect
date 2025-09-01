import 'package:freezed_annotation/freezed_annotation.dart';

part 'court.freezed.dart';
part 'court.g.dart';

@freezed
class Court with _$Court {
  const factory Court({
    required String id,
    required int number,
    required String name,
    @Default(CourtStatus.available) CourtStatus status,
    String? description,
    @Default(true) bool isActive,
  }) = _Court;

  factory Court.fromJson(Map<String, dynamic> json) => _$CourtFromJson(json);
}

@JsonEnum()
enum CourtStatus {
  @JsonValue('available')
  available,
  @JsonValue('occupied')
  occupied,
  @JsonValue('reserved')
  reserved,
  @JsonValue('maintenance')
  maintenance,
}

@freezed
class CourtBooking with _$CourtBooking {
  const factory CourtBooking({
    required String id,
    required String courtId,
    required String userId,
    required DateTime startTime,
    required DateTime endTime,
    required BookingStatus status,
    String? notes,
    DateTime? createdAt,
  }) = _CourtBooking;

  factory CourtBooking.fromJson(Map<String, dynamic> json) => _$CourtBookingFromJson(json);
}

@JsonEnum()
enum BookingStatus {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('pending')
  pending,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}