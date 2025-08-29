cmake_minimum_required(VERSION 3.20)

project(plasmoid-ydinfo)
 
find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

set(QT_MAJOR_VERSION 6)

include(KDEInstallDirs6)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(Plasma REQUIRED)

add_subdirectory(translations)

plasma_install_package(package com.ylsoftware.plasma.ydinfo)
