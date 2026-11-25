import '../../../core/utils/prayer_calc.dart';

class City {
  final String name;
  final String cc; // country code
  final double lat;
  final double lng;
  const City(this.name, this.cc, this.lat, this.lng);
}

const prayerCities = <City>[
  // Pakistan
  City('Karachi', 'PK', 24.8607, 67.0011),
  City('Lahore', 'PK', 31.5497, 74.3436),
  City('Islamabad', 'PK', 33.6844, 73.0479),
  City('Rawalpindi', 'PK', 33.5651, 73.0169),
  City('Faisalabad', 'PK', 31.4504, 73.1350),
  City('Multan', 'PK', 30.1978, 71.4711),
  City('Peshawar', 'PK', 34.0151, 71.5249),
  City('Quetta', 'PK', 30.1798, 66.9750),
  City('Gujranwala', 'PK', 32.1877, 74.1945),
  City('Sialkot', 'PK', 32.4945, 74.5229),
  City('Hyderabad', 'PK', 25.3960, 68.3578),
  // India
  City('Delhi', 'IN', 28.6139, 77.2090),
  City('Mumbai', 'IN', 19.0760, 72.8777),
  City('Hyderabad (India)', 'IN', 17.3850, 78.4867),
  City('Bengaluru', 'IN', 12.9716, 77.5946),
  City('Kolkata', 'IN', 22.5726, 88.3639),
  City('Chennai', 'IN', 13.0827, 80.2707),
  City('Lucknow', 'IN', 26.8467, 80.9462),
  City('Ahmedabad', 'IN', 23.0225, 72.5714),
  // Saudi Arabia
  City('Riyadh', 'SA', 24.7136, 46.6753),
  City('Jeddah', 'SA', 21.4858, 39.1925),
  City('Makkah', 'SA', 21.3891, 39.8579),
  City('Madinah', 'SA', 24.5247, 39.5692),
  City('Dammam', 'SA', 26.4207, 50.0888),
  // UAE
  City('Dubai', 'AE', 25.2048, 55.2708),
  City('Abu Dhabi', 'AE', 24.4539, 54.3773),
  City('Sharjah', 'AE', 25.3463, 55.4209),
  // Baqi Gulf
  City('Kuwait City', 'KW', 29.3759, 47.9774),
  City('Doha', 'QA', 25.2854, 51.5310),
  City('Manama', 'BH', 26.2285, 50.5860),
  City('Muscat', 'OM', 23.5880, 58.3829),
  // UK
  City('London', 'GB', 51.5074, -0.1278),
  City('Birmingham', 'GB', 52.4862, -1.8904),
  City('Manchester', 'GB', 53.4808, -2.2426),
  City('Bradford', 'GB', 53.7960, -1.7594),
  City('Glasgow', 'GB', 55.8642, -4.2518),
  // USA
  City('New York', 'US', 40.7128, -74.0060),
  City('Chicago', 'US', 41.8781, -87.6298),
  City('Houston', 'US', 29.7604, -95.3698),
  City('Los Angeles', 'US', 34.0522, -118.2437),
  City('Dearborn', 'US', 42.3223, -83.1763),
];

PrayerMethod methodForCountry(String cc) {
  switch (cc) {
    case 'PK':
    case 'IN':
      return PrayerMethod.karachi;
    case 'SA':
    case 'BH':
    case 'OM':
      return PrayerMethod.ummAlQura;
    case 'AE':
      return PrayerMethod.dubai;
    case 'KW':
      return PrayerMethod.kuwait;
    case 'QA':
      return PrayerMethod.qatar;
    case 'US':
      return PrayerMethod.isna;
    default:
      return PrayerMethod.mwl;
  }
}

bool hanafiForCountry(String cc) => cc == 'PK' || cc == 'IN';

/// GPS ki location ke sab se qareebi shehar (offline).
(City, double)? nearestCity(Coords c) {
  City? best;
  var bestKm = double.infinity;
  for (final city in prayerCities) {
    final km = distanceKm(c, Coords(city.lat, city.lng));
    if (km < bestKm) {
      bestKm = km;
      best = city;
    }
  }
  return best == null ? null : (best, bestKm);
}