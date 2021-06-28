# Changelog

All notable changes to FairRoot will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),

## 19.0 (UNRELEAASED) - 2021-XX-XX

### Breaking Changes
* We have moved away from our custom ROOT find module, and now use the native cmake package of ROOT.
  * This means, that all library depedencies of the type `Core` are either not working at all, or might not work as expected. Please upgrade all of them to be like `ROOT::Core` .
  * This also means, that you need to add an `include(ROOTMacros)` after your `find_package2(? ROOT ?)`.
  * `ROOT_VERSION_NUMBER` is gone. Use `ROOT_VERSION` (which is the dotted version number) and VERSION_GREATER/etc now.
* `find_package2` has been externalized into [FairCMakeModules](https://github.com/FairRootGroup/FairCMakeModules) and is not any more installed together with FairRoot
  * Please highly consider installing FairCMakeModules as a dependency of FairRoot and for your own usage. FairSoft will ship it soon.
  * After installation, it should be as easy as this in your own code:
    ```cmake
    find_package(FairCMakeModules 0.2 REQUIRED)
    include(FairFindPackage2)
    ```
* Dropped `CheckCXX11Features`
  * FairRoot assumes a recent compiler that fully supports C++11.
  * Remove the following things from your `CMakeLists.txt`:
    * ```cmake
      Set(CheckSrcDir "${FAIRROOTPATH}/share/fairbase/cmake/checks")`
      ```
    * ```cmake
      include(CheckCXX11Features)`
      ```
    * ```cmake
      IF(HAS_CXX11_SHAREDPOINTER)
        Add_Definitions(-DHAS_SHAREDPOINTER)
      ENDIF(HAS_CXX11_SHAREDPOINTER)
      ```
  * If your C++ code depends on `HAS_SHAREDPOINTER` being set, rewrite it accordingly.
  * If any of your CMake code depends on `HAS_CXX11_*` being set, rewrite it accordingly.
  * If your code has specific C++ needs, consider CMake's `target_compile_features()`.
* Dropped `CHECK_EXTERNAL_PACKAGE_INSTALL_DIR`
  * Just remove it from your `CMakeLists.txt`.

### Deprecated
* Deprecating MbsAPI
  * This release deprecates MbsAPI. We plan to remove it completely in the next major release.
  * If you need it, speak up NOW.
  * It is disabled by default in this release.
  * It can still be enabled with `-DBUILD_MBS=ON`.

### Other Notable Changes
* Consider calling `fairroot_check_root_cxxstd_compatibility()`
  in your `CMakeLists.txt`.
* `fairsoft-config` isn't searched for and not needed any more.

### Example Changes in Experiment Repos
* https://github.com/R3BRootGroup/R3BRoot/pull/413