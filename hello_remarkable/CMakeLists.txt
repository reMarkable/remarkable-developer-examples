cmake_minimum_required(VERSION 3.16)
project(hello_remarkable VERSION 0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(hello_remarkable main.cpp)
qt_add_qml_module(hello_remarkable
    URI remarkable_example
    VERSION 1.0
    QML_FILES Main.qml)

target_link_libraries(hello_remarkable PRIVATE Qt6::Quick)
