import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForcast extends StatefulWidget {
  final Map<String, dynamic> currentvalue;
  final String city;
  final List<dynamic> pastweek;
  final List<dynamic> next7days;

  const WeeklyForcast({
    super.key,
    required this.city,
    required this.currentvalue,
    required this.pastweek,
    required this.next7days,
  });

  @override
  State<WeeklyForcast> createState() => _WeeklyForcastState();
}

class _WeeklyForcastState extends State<WeeklyForcast> {
  @override
  Widget build(BuildContext context) {

    String formateApiData(String dataString) {
      DateTime date = DateTime.parse(dataString);
      return DateFormat("d MMMM, EEEE").format(date);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Current Weather
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.city,
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
                      "${widget.currentvalue['temp_c']}°C",
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "${widget.currentvalue['condition']['text']}",
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),

                    Image.network(
                      "https:${widget.currentvalue['condition']?['icon'] ?? ''}",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              /// Next 7 Days Forecast
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Next 7 Days Forecast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ...widget.next7days.map((day) {

                final data = day['date'] ?? "";
                final condition = day['day']?['condition']?['text'] ?? '';
                final icon = day['day']?['condition']?['icon'] ?? '';

                /// FIXED spelling
                final maxtemp = day['day']?['maxtemp_c'] ?? '';
                final mintemp = day['day']?['mintemp_c'] ?? '';

                return ListTile(
                  leading: Image.network('https:$icon', width: 40),
                  title: Text(
                    formateApiData(data),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(
                    "$condition $mintemp°C - $maxtemp°C",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }).toList(),

              /// Previous 7 Days Forecast
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Previous 7 Days Forecast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ...widget.pastweek.map((day) {

                /// FIXED key
                final forecastDay = day['forecast']?['forecastday'];

                if (forecastDay == null || forecastDay.isEmpty) {
                  return const SizedBox.shrink();
                }

                final forecast = forecastDay[0];

                final data = forecast['date'] ?? "";
                final condition = forecast['day']?['condition']?['text'] ?? '';
                final icon = forecast['day']?['condition']?['icon'] ?? '';

                /// FIXED spelling
                final maxtemp = forecast['day']?['maxtemp_c'] ?? '';
                final mintemp = forecast['day']?['mintemp_c'] ?? '';

                return ListTile(
                  leading: Image.network('https:$icon', width: 40),
                  title: Text(
                    formateApiData(data),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(
                    "$condition $mintemp°C - $maxtemp°C",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }).toList(),

            ],
          ),
        ),
      ),
    );
  }
}