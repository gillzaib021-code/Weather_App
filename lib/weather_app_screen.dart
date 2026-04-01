import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/provider/theme_provider.dart';
import 'package:weather_application/services/api_services.dart';
import 'package:weather_application/theme/weekly_forcast/weekly_forcast.dart';

class WeatherAppScreen extends ConsumerStatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  ConsumerState<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends ConsumerState<WeatherAppScreen> {
  final _weatherservices = WeatherApiServices();
  String city = "Hafizabad"; // initially city
  String country = '';
  Map<String, dynamic> currentvalue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastweek = [];
  List<dynamic> next7days = [];
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    _fetchwether(); // function call (same name as original)
  }

  Future<void> _fetchwether() async {
    setState(() {
      isloading = true;
    });

    try {
      final forecast = await _weatherservices.getHourlyForcast(city);
      final past = await _weatherservices.getPastsevenDayWeather(city);

      setState(() {
        currentvalue = forecast['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        next7days = forecast['forecast']?['forecastday'] ?? [];
        pastweek = past;
        city = forecast['location']?['name'] ?? city;
        country = forecast['location']?['country'] ?? '';
        isloading = false;
      });
    } catch (e) {
      setState(() {
        currentvalue = {};
        hourly = [];
        pastweek = [];
        next7days = [];
        isloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('City not found or invalid. Please enter a valid city'),
        ),
      );
    }
  }

  String formatetime(String timestring) {
    DateTime time = DateTime.parse(timestring);
    return DateFormat.j().format(time); //1am, 5pm, etc
  }

  @override
  Widget build(BuildContext context) {
    final thememode = ref.watch(themenotifierprovider);
    final notifier = ref.read(themenotifierprovider.notifier);
    final isDark = thememode == ThemeMode.dark;

    String iconPath = currentvalue['condition']?['icon'] ?? '';
    String imageUrl = iconPath.isNotEmpty ? "https:$iconPath" : '';

    Widget imageWidget = imageUrl.isNotEmpty
        ? Image.network(imageUrl, height: 200, width: 200, fit: BoxFit.cover)
        : SizedBox();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(width: 25),
          SizedBox(
            height: 50,
            width: 250,
            child: TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please enter a city name')),
                  );
                  return;
                }
                city = value.trim();
                _fetchwether();
              },
              decoration: InputDecoration(
                labelText: 'Search City',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.surface,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: notifier.toggleTheme,
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.black : Colors.white,
              size: 25,
            ),
          ),
          SizedBox(width: 25),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (isloading)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (currentvalue.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$city${country.isNotEmpty ? ',$country' : ''}',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "${currentvalue['temp_c']}°C",
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "${currentvalue['condition']['text']}",
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    // SizedBox(height: 20),
                    imageWidget,
                    Padding(
                      padding: EdgeInsetsGeometry.all(15),
                      child: Container(
                        height: 100,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary,
                              offset: Offset(1, 1),
                              blurRadius: 5,
                              spreadRadius: 0.2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //for Humidity
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/4148/4148460.png",
                                  height: 30,
                                  width: 30,
                                ),
                                Text(
                                  "${currentvalue['humidity']}%",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),

                            //for wind,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://static.vecteezy.com/system/resources/thumbnails/073/138/230/small/blue-wind-turbine-icon-with-three-blades-minimalistic-style-symbolizing-renewable-energy-sustainability-clean-power-and-eco-friendly-technology-isolated-on-transparency-background-png.png",
                                  height: 30,
                                  width: 30,
                                ),
                                Text(
                                  "${currentvalue['wind_kph']} kph",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Wind",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),

                            //for max temeperature
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/1684/1684375.png",
                                  height: 30,
                                  width: 30,
                                ),
                                Text(
                                  hourly.isNotEmpty
                                      ? "${hourly.map((h) => h["temp_c"] as num).reduce((a, b) => a > b ? a : b)}°C"
                                      : "N/A",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Max Temp",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                    Container(
                      height: 250,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Today Forcast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WeeklyForcast(
                                          city: city,
                                          currentvalue: currentvalue,
                                          pastweek: pastweek,
                                          next7days: next7days,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Weekly Forcast',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: hourly.length,
                              itemBuilder: (context, index) {
                                final hour = hourly[index];
                                final now = DateTime.now();
                                final hourtime = DateTime.parse(hour["time"]);
                                final isCurrenthour =
                                    now.hour == hourtime.hour &&
                                    now.day == hourtime.day;
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 70,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isCurrenthour
                                          ? Colors.orangeAccent
                                          : Colors.black38,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          isCurrenthour
                                              ? "Now"
                                              : formatetime(hour["time"]),
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Image.network(
                                          "https:${hour['condition']?['icon']}",
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "${hour["temp_c"]}°C",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
