#include <chrono>
#include <iostream>
#include <time.h>
#include <utility>
#include <vector>

using TimePoint = std::chrono::system_clock::time_point;

class Session {
  std::vector<std::pair<TimePoint, TimePoint>> laps;
  TimePoint start;

public:
  uint32_t start_lap() {
    
  }
};

class User {
public:
  void start_session();
};

int main() { return 0; }