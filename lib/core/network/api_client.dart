import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../constants/app_constants.dart';
import '../../shared/models/user.dart';
import '../../shared/models/court.dart';
import '../../shared/models/ladder.dart';
import '../../shared/models/tournament.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth endpoints
  @POST('/auth/login')
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> credentials);

  @POST('/auth/register')
  Future<Map<String, dynamic>> register(@Body() Map<String, dynamic> userData);

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/auth/profile')
  Future<User> getProfile();

  @PUT('/auth/profile')
  Future<User> updateProfile(@Body() User user);

  // Users endpoints
  @GET('/users')
  Future<List<User>> getUsers();

  @GET('/users/{id}')
  Future<User> getUserById(@Path() String id);

  @POST('/users/invite')
  Future<Map<String, dynamic>> inviteUser(@Body() Map<String, dynamic> invitation);

  // Courts endpoints
  @GET('/courts')
  Future<List<Court>> getCourts();

  @GET('/courts/{id}')
  Future<Court> getCourtById(@Path() String id);

  @GET('/courts/{id}/bookings')
  Future<List<CourtBooking>> getCourtBookings(
    @Path() String id,
    @Query('date') String date,
  );

  @POST('/bookings')
  Future<CourtBooking> createBooking(@Body() Map<String, dynamic> booking);

  @PUT('/bookings/{id}')
  Future<CourtBooking> updateBooking(
    @Path() String id,
    @Body() Map<String, dynamic> booking,
  );

  @DELETE('/bookings/{id}')
  Future<void> cancelBooking(@Path() String id);

  // Ladder endpoints
  @GET('/ladder')
  Future<List<LadderEntry>> getLadderRankings(@Query('seasonId') String seasonId);

  @GET('/ladder/seasons')
  Future<List<Season>> getSeasons();

  @POST('/matches')
  Future<Match> createMatch(@Body() Map<String, dynamic> match);

  @PUT('/matches/{id}/result')
  Future<Match> updateMatchResult(
    @Path() String id,
    @Body() MatchResult result,
  );

  // Tournament endpoints
  @GET('/tournaments')
  Future<List<Tournament>> getTournaments();

  @GET('/tournaments/{id}')
  Future<Tournament> getTournamentById(@Path() String id);

  @POST('/tournaments')
  Future<Tournament> createTournament(@Body() Map<String, dynamic> tournament);

  @POST('/tournaments/{id}/register')
  Future<TournamentParticipant> registerForTournament(@Path() String id);

  @DELETE('/tournaments/{id}/register')
  Future<void> withdrawFromTournament(@Path() String id);

  @GET('/tournaments/{id}/matches')
  Future<List<TournamentMatch>> getTournamentMatches(@Path() String id);

  @PUT('/tournaments/{id}/matches/{matchId}/result')
  Future<TournamentMatch> updateTournamentMatchResult(
    @Path() String id,
    @Path() String matchId,
    @Body() TournamentMatchResult result,
  );
}