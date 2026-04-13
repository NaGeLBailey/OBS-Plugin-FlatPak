# OBS Plugins that NaGeL Needs and its not on Flathub

## Requirments

1. flatpak-builder  
just install it in your distro
2. SDKs...  

```fish
flatpak install org.freedesktop.Sdk.Extension.rust-stable/x86_64/25.08
flatpak install org.freedesktop.Sdk//25.08
flatpak install org.kde.Sdk//6.6
```

## Usage

```bash
./build.sh <folderName or all>
```

## Status

### SourceCopy

Works!  
It has been Added to Flathub!

### ClosedCaption

Flatpak builds, and add workaround to make it work:
`--env=LD_LIBRARY_PATH=/app/lib/`  
KDE Desktop file Command line argument:  
`run --env=LD_LIBRARY_PATH=/app/lib/ --branch=stable --arch=x86_64 --command=obs com.obsproject.Studio`

### Noise

Works!

## LocalVocal

works but has issues with BackgroundRemoval  
<https://github.com/royshil/obs-localvocal/issues/300>

Has some issues: <https://github.com/royshil/obs-localvocal/issues/301>

## Shadertastic

Okay it works now it just has Dependency issue with LocalVocal about libonnxruntime.... the same isue as localVocal has BackgroudRemoval

## RetroEffects

added it bonly black screen.

## Changelog

### 2026-04-13

Added retro effects, first the shader files was not found by the plugin i solved that, now it just blank/black screen... yet if i use non flatpkversio it works...  
I really want the flatpak version to work...

Also got some help on Shadertastic stuff...

```txt
you can force fetchcontent to be offline and figure out where to put the downloaded sources.

<https://github.com/flathub/org.freedesktop.LinuxAudio.Plugins.jc303/blob/branch/25.08/org.freedesktop.LinuxAudio.Plugins.jc303.json#L19>

this is an example
the cmake documentation is objecting against FETCHCONTENT_FULLY_DISCONNECTED for that situation
<https://cmake.org/cmake/help/latest/module/FetchContent.html#variable:FETCHCONTENT_FULLY_DISCONNECTED>
```

### 2026-04-12

SourceCopy has been added to flathub so thisisnt needed anymore! \o/
Deleting it with this commit!

Shadertasticworks it just has  some conflicts...
has Dependency issue with LocalVocal about libonnxruntime.... the same isue as localVocal has BackgroudRemoval

`Anyway thank you I will try to Override FetchContent first with OVERRIDE_FIND_PACKAGE if its possible if its not  then i need to figure something else out.`

### 2026-04-11

Added Noise. And it works!

Added Shadertastic. It builds but it adds it stuff to the wrong location.
Can I makea custom CmakeList.txt?

### 2026-04-10

Tried building ClosedCaption in flatpak context but could not make it happen.
But the work around works: <https://github.com/ratwithacompiler/OBS-captions-plugin/issues/155#issuecomment-3498925450>

WorkingLocal Vocal but has some issues with BackgroudRemoval...

LocalVocal has some more issues...
If I try to use the included build.sh  it builds, but the plugin never shows up in OBS.
If I dont use it but  call the builder myself only generic builds nvdia gest the following error:

```log
❯ ./build.sh LocalVocal
building LocalVocal...
==================================================
 Building LocalVocal 
==================================================
Emptying app dir 'build'
Downloading sources
Starting build of com.obsproject.Studio.Plugin.LocalVocal
Cache hit for openblas, skipping build
Cache hit for whispercpp, skipping build
Cache hit for ctranslate2, skipping build
Cache hit for sentencepiece, skipping build
Cache hit for opencl-headers, skipping build
Cache hit for qt-uic-wrapper, skipping build
Cache miss, checking out last cache hit
========================================================================
Building module obs-localvocal in /home/nagel-stream/workspace/OBS-Plugin-FlatPak/plugins/LocalVocal/flatpak/.flatpak-builder/build/obs-localvocal-4
========================================================================
-- The C compiler identification is GNU 15.2.0
-- The CXX compiler identification is GNU 15.2.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- CMake 4 detected
-- Found SIMDe: /app/include (found version "0.8.2")
-- Found Threads: TRUE
-- Performing Test HAVE_STDATOMIC
-- Performing Test HAVE_STDATOMIC - Success
-- Found WrapAtomic: TRUE
-- Found OpenGL: /usr/lib/x86_64-linux-gnu/libOpenGL.so
-- Found WrapOpenGL: TRUE
-- Found XKB: /usr/lib/x86_64-linux-gnu/libxkbcommon.so (found suitable version "1.11.0", minimum required is "0.5.0")
-- Found CURL: /usr/lib/x86_64-linux-gnu/cmake/CURL/CURLConfig.cmake (found version "8.15.0")
-- Looking for sgemm_
-- Looking for sgemm_ - found
-- Found BLAS: /app/plugins/LocalVocal/lib/libopenblas.so
-- Found ccache: /usr/bin/ccache
-- Found Vulkan: /usr/lib/x86_64-linux-gnu/libvulkan.so (found version "1.4.321") found components: glslc glslangValidator
-- Found Python3: /usr/bin/python3.13 (found version "3.13.12") found components: Interpreter
CMake Error at /usr/share/cmake-4.2/Modules/FindCUDAToolkit.cmake:921 (message):
  Could not find `nvcc` executable in path specified by variable
  CUDAToolkit_ROOT=/usr/local/cuda-12.8/
Call Stack (most recent call first):
  /usr/share/cmake-4.2/Modules/FindCUDAToolkit.cmake:951 (_CUDAToolkit_find_failure_message)
  cmake/BuildWhispercpp.cmake:247 (find_package)
  CMakeLists.txt:90 (include)


-- Configuring incomplete, errors occurred!
Error: module obs-localvocal: Child process exited with code 1
```

staying with my build and generic but i do want to use CUDA if possible...

### 2026-04-09

First Day and one plugin works rest needs to made later  
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](obsplugins-greenNeeded.png)
