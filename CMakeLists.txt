cmake_minimum_required(VERSION 3.0)

project(plasmoid-ydinfo)
 
find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(KF5Plasma REQUIRED)

add_subdirectory(translations)

plasma_install_package(package com.ylsoftware.plasma.ydinfo)
