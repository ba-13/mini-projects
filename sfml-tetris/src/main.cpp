#include <SFML/Graphics.hpp>
#include <glad/glad.h>
#include <iostream>

int main() {
  sf::ContextSettings settings;
  settings.depthBits = 24;        // Set depth bits
  settings.stencilBits = 8;       // Set stencil bits
  settings.antiAliasingLevel = 4; // Set anti-aliasing level
  settings.majorVersion = 4;      // Set OpenGL major version
  settings.minorVersion = 6;      // Set OpenGL minor version
  auto window =
      sf::RenderWindow(sf::VideoMode({400u, 300u}), "CMake SFML Project",
                       sf::Style::Default, sf::State::Windowed, settings);
  // window.setFramerateLimit(144);
  window.setVerticalSyncEnabled(true);
  gladLoadGL();
  bool active = window.setActive(true);
  if (!active) {
    std::cerr << "Failed to activate the window context." << std::endl;
    return -1;
  }
  bool running = true;

  // event handlers
  const auto onClose = [&running](const sf::Event::Closed &) {
    running = false;
  };

  const auto onEscape = [&window](const sf::Event::KeyPressed &key) {
    if (key.scancode == sf::Keyboard::Scancode::Escape) {
      window.close();
    }
  };

  const auto onFocusGained = [&window](const sf::Event::FocusGained &) {
    std::cout << "Focus gained" << std::endl;
    window.setSize({800u, 600u});
  };

  const auto onFocusLost = [&window](const sf::Event::FocusLost &) {
    std::cout << "Focus lost" << std::endl;
    window.setSize({400u, 300u});
  };

  const auto mouseMoved = [](const sf::Event::MouseMovedRaw &mouse) {
    std::cout << "Mouse moved to: (" << mouse.delta.x << ", " << mouse.delta.y
              << ")" << std::endl;
  };

  while (running) {
    window.handleEvents(onClose, onEscape, onFocusGained, onFocusLost,
                        mouseMoved);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Draw a rectangle
    sf::RectangleShape rectangle(sf::Vector2f(100.f, 50.f));
    rectangle.setFillColor(sf::Color::Green);
    rectangle.setPosition({150.f, 125.f});
    window.draw(rectangle);

    window.display();
  }

  window.setActive(false);
  window.close();
}
