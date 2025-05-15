import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_replacement/Components/constants.dart';

const String _apiBaseUrl = "https://player-replacement-finder.onrender.com";

const String _endpointSquadMinutes = "/plot_squad_minutes";
const String _endpointLeaguePossession = "/plot_league_possession";
const String _endpointLeagueXgComparison = "/plot_league_xg_comparison";
const String _endpointQualityVolumeScatter = "/plot_quality_volume_scatter";
const String _endpointSquadTopPerformers = "/plot_squad_top_performers";

const String _headerKeySquadName = 'squad-name';
const String _headerKeyLeagueName = 'league-name';

class TeamsDashboard extends StatefulWidget {
  final String teamName;
  final String leagueName;

  const TeamsDashboard({
    required this.teamName,
    required this.leagueName,
    super.key,
  });

  @override
  State<TeamsDashboard> createState() => _TeamsDashboardState();
}

class _TeamsDashboardState extends State<TeamsDashboard> {
  Uint8List? minutesImage;
  Uint8List? possessionImage;
  Uint8List? xgImage;
  Uint8List? qualityImage;
  Uint8List? topPerformersImage;

  bool isMinutesLoading = true;
  bool isPossessionLoading = true;
  bool isXgLoading = true;
  bool isQualityLoading = true;
  bool isTopPerformersLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllDashboardData();
  }

  void _loadAllDashboardData() {
    _fetchAndSetImage(
      endpoint: _endpointSquadMinutes,
      onDataReceived: (data) => minutesImage = data,
      onLoadingChanged: (isLoading) => isMinutesLoading = isLoading,
      plotTitleForDebug: "Squad Playing Minutes",
    );
    _fetchAndSetImage(
      endpoint: _endpointLeaguePossession,
      onDataReceived: (data) => possessionImage = data,
      onLoadingChanged: (isLoading) => isPossessionLoading = isLoading,
      plotTitleForDebug: "League Possession",
    );
    _fetchAndSetImage(
      endpoint: _endpointLeagueXgComparison,
      onDataReceived: (data) => xgImage = data,
      onLoadingChanged: (isLoading) => isXgLoading = isLoading,
      plotTitleForDebug: "Squad XG Comparison",
    );
    _fetchAndSetImage(
      endpoint: _endpointQualityVolumeScatter,
      onDataReceived: (data) => qualityImage = data,
      onLoadingChanged: (isLoading) => isQualityLoading = isLoading,
      plotTitleForDebug: "Squad Quality/Volume",
    );
    _fetchAndSetImage(
      endpoint: _endpointSquadTopPerformers,
      onDataReceived: (data) => topPerformersImage = data,
      onLoadingChanged: (isLoading) => isTopPerformersLoading = isLoading,
      queryParameters: {
        'metric_col': 'xG.1',
        'metric_label': 'xG per 90',
      },
      plotTitleForDebug: "Squad Top Performers (xG per 90)",
    );
  }

  Future<void> _fetchAndSetImage({
    required String endpoint,
    required void Function(Uint8List? data) onDataReceived,
    required void Function(bool isLoading) onLoadingChanged,
    Map<String, String> additionalHeaders = const {},
    Map<String, String> queryParameters = const {},
    required String plotTitleForDebug,
  }) async {
    try {
      final Map<String, String> headers = {
        _headerKeySquadName: widget.teamName,
        _headerKeyLeagueName: widget.leagueName,
        ...additionalHeaders,
      };

      Uri baseUri = Uri.parse(_apiBaseUrl);
      Uri finalUri = baseUri.resolve(endpoint);

      if (queryParameters.isNotEmpty) {
        finalUri = finalUri.replace(queryParameters: {
          ...finalUri.queryParametersAll,
          ...queryParameters,
        });
      }

      // print("Fetching: $plotTitleForDebug, URL: ${finalUri.toString()}, Headers: $headers");

      final response = await http.get(finalUri, headers: headers);

      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            onDataReceived(response.bodyBytes);
            onLoadingChanged(false);
          });
        } else {
          // print("Failed for $plotTitleForDebug. Status: ${response.statusCode}, Body: ${response.body}");
          setState(() {
            onDataReceived(null);
            onLoadingChanged(false);
          });
        }
      }
    } catch (e) {
      // print("Error fetching $plotTitleForDebug: $e");
      if (mounted) {
        setState(() {
          onDataReceived(null);
          onLoadingChanged(false);
        });
      }
    }
  }

  Widget _buildPlotCard({
    required String title,
    required bool isLoading,
    required Uint8List? imageData,
    required String errorMessage,
    required double cardMinHeight,
    required double imageDisplayWidth,
    required double errorFontSize,
  }) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor, // Using kPrimaryColor for title
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: cardMinHeight *
                      0.7), // Ensure content area has min height
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : imageData != null
                      ? SizedBox(
                          width: imageDisplayWidth,
                          child: Image.memory(
                            imageData,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                fontSize: errorFontSize,
                                color: Colors.red.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final double cardMinHeight = SizeConfig.isMobile
        ? h * 0.3
        : SizeConfig.isTablet
            ? h * 0.35
            : h * 0.45;

    final double imageDisplayWidth = SizeConfig.isMobile
        ? w * 0.8
        : SizeConfig.isTablet
            ? w * 0.7
            : w * 0.6;

    final double errorFontSize = SizeConfig.isMobile
        ? h * 0.018
        : SizeConfig.isTablet
            ? h * 0.020
            : h * 0.022;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: h * 0.12,
        backgroundColor: kPrimaryColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: kSecondaryColor),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DataFC',
              style: TextStyle(
                color: kSecondaryColor,
                fontFamily: 'Nevis',
                fontSize: SizeConfig.isMobile
                    ? h * 0.03
                    : SizeConfig.isTablet
                        ? h * 0.035
                        : h * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The ultimate football data club',
              style: TextStyle(
                color: kSecondaryColor.withOpacity(0.85),
                fontFamily: 'Nevis',
                fontSize: SizeConfig.isMobile
                    ? h * 0.011
                    : SizeConfig.isTablet
                        ? h * 0.013
                        : h * 0.015,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: h * 0.02,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.015),
                child: Text(
                  widget.teamName,
                  style: TextStyle(
                    fontSize: SizeConfig.isMobile
                        ? h * 0.032
                        : SizeConfig.isTablet
                            ? h * 0.038
                            : h * 0.045,
                    fontFamily: 'Barcelona',
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildPlotCard(
                title: "Squad Playing Minutes",
                isLoading: isMinutesLoading,
                imageData: minutesImage,
                errorMessage: 'Playing minutes data could not be fetched.',
                cardMinHeight: cardMinHeight,
                imageDisplayWidth: imageDisplayWidth,
                errorFontSize: errorFontSize,
              ),
              _buildPlotCard(
                title: "League Possession Comparison",
                isLoading: isPossessionLoading,
                imageData: possessionImage,
                errorMessage: 'Possession data could not be fetched.',
                cardMinHeight: cardMinHeight,
                imageDisplayWidth: imageDisplayWidth,
                errorFontSize: errorFontSize,
              ),
              _buildPlotCard(
                title: "Squad xG vs League Average",
                isLoading: isXgLoading,
                imageData: xgImage,
                errorMessage: 'xG comparison data could not be fetched.',
                cardMinHeight: cardMinHeight,
                imageDisplayWidth: imageDisplayWidth,
                errorFontSize: errorFontSize,
              ),
              _buildPlotCard(
                title: "Shot Quality vs Volume",
                isLoading: isQualityLoading,
                imageData: qualityImage,
                errorMessage: 'Shot quality/volume data could not be fetched.',
                cardMinHeight: cardMinHeight,
                imageDisplayWidth: imageDisplayWidth,
                errorFontSize: errorFontSize,
              ),
              _buildPlotCard(
                title: "Top Performers (xG per 90)",
                isLoading: isTopPerformersLoading,
                imageData: topPerformersImage,
                errorMessage: 'Top performers data could not be fetched.',
                cardMinHeight: cardMinHeight,
                imageDisplayWidth: imageDisplayWidth,
                errorFontSize: errorFontSize,
              ),
              SizedBox(height: h * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
