# sf::Window

This is an important limitation of most operating systems: the event loop (more precisely, the pollEvent or waitEvent function) must be called in the same thread that created the window. This means that if you want to create a dedicated thread for event handling, you'll have to make sure that the window is created in this thread too. If you really want to split things between threads, it is more convenient to keep event handling in the main thread and move the rest (rendering, physics, logic, ...) to a separate thread instead. This configuration will also be compatible with the other limitation described below.

If a key is held, multiple KeyPressed events will be generated, at the default operating system delay (i.e. the same delay that applies when you hold a letter in a text editor). To disable repeated KeyPressed events, you can call window.setKeyRepeatEnabled(false). On the flip side, it is obvious that KeyReleased events can never be repeated.

## To produce smooth movement

Sometimes, people try to react to KeyPressed events directly to implement smooth movement. Doing so will not produce the expected effect, because when you hold a key you only get a few events (remember, the repeat delay). To achieve smooth movement with events, you must use a boolean that you set on KeyPressed and clear on KeyReleased; you can then move (independently of events) as long as the boolean is set.

The other (easier) solution to produce smooth movement is to use real-time keyboard input with sf::Keyboard (see the dedicated tutorial).

## Real time input

Real-time input allows you to query the global state of keyboard, mouse and joysticks at any time ("is this button currently pressed?", "where is the mouse currently?") while events notify you when something happens ("this button was pressed", "the mouse has moved").

# Windowless context

Sometimes it might be necessary to call OpenGL functions without an active window, and thus no OpenGL context. For example, when you load textures from a separate thread, or before the first window is created. SFML allows you to create window-less contexts with the sf::Context class. All you have to do is instantiate it to get a valid context.