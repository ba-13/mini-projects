cmake_minimum_required(VERSION 3.16)
project(chitchat VERSION 1.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

configure_file(include/chitchat/config.h.in include/chitchat/config.h)

find_package (Threads REQUIRED)

include_directories(./include)

add_library(socketLib ./src/lib.cpp)
target_include_directories(socketLib PUBLIC ${CMAKE_BINARY_DIR}/include)

add_executable(client ./src/client.cpp)
target_include_directories(client PUBLIC
                            ${CMAKE_BINARY_DIR}/include)
target_link_libraries(client PUBLIC socketLib Threads::Threads)

add_executable(server ./src/server.cpp)
target_include_directories(server PUBLIC
                            ${CMAKE_BINARY_DIR}/include)
target_link_libraries(server PUBLIC socketLib Threads::Threads)
