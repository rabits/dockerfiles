Qt toolchain images
===================

* qt:5.4-desktop
* qt:5.4-android
* qt:5.7-desktop
* qt:5.7-android
* qt:5.9-desktop
* qt:5.9-android
* qt:5.10-desktop
* qt:5.10-android
* qt:5.11-desktop
* qt:5.11-android
* qt:5.12-desktop
* qt:5.12-android
* qt:5.13-desktop
* qt:5.13-android-armv7
* qt:5.13-android-arm64
* qt:5.14-desktop
* qt:5.14-android

## Usage:

1. Clone the project repository:
    ```
    host$ git clone https://github.com/ACCOUNT/PROJECT.git
    ```
2. Run the docker container:
    * For `desktop`:
        ```
        host$ docker run -it --rm --volume="${PWD}/PROJECT:/home/user/project:ro" rabits/qt:5.14-desktop
        ```
    * For `android`:
        ```
        host$ docker run -it --rm --volume="${PWD}/PROJECT:/home/user/project:ro" rabits/qt:5.14-android
        ```
3. Install the additional build dependencies (example)
    ```
    docker$ sudo apt update; sudo DEBIAN_FRONTEND=noninteractive apt install -y gnupg2
    docker$ curl https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
    docker$ echo 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main' | sudo tee /etc/apt/sources.list.d/llvm-10.list
    docker$ sudo apt update ; sudo apt install -y clang-format-10
    ```
4. Create build directory:
    ```
    docker$ mkdir -p build && cd build
    ```
5. Generate the build scripts
    * For `desktop`:
        ```
        docker$ cmake ../project -G Ninja "-DCMAKE_PREFIX_PATH:PATH=${QT_DESKTOP}"
        ```
    * For `android` (MultiABI):
        ```
        docker$ cmake ../project -G Ninja -DCMAKE_BUILD_TYPE:STRING=Release -DANDROID_ABI:STRING=armeabi-v7a -DANDROID_BUILD_ABI_arm64-v8a:BOOL=ON -DANDROID_BUILD_ABI_x86:BOOL=ON -DANDROID_BUILD_ABI_x86_64:BOOL=ON "-DANDROID_NATIVE_API_LEVEL:STRING=${ANDROID_NATIVE_API_LEVEL}" "-DANDROID_SDK:PATH=${ANDROID_SDK_ROOT}" "-DANDROID_NDK:PATH=${ANDROID_NDK_ROOT}" "-DCMAKE_PREFIX_PATH:PATH=${QT_ANDROID}" "-DCMAKE_FIND_ROOT_PATH:STRING=${QT_ANDROID}" "-DCMAKE_TOOLCHAIN_FILE:PATH=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake"
        ```
6. Build the binaries:
    ```
    docker$ cmake --build .
    ```

## Build the container image 5.14

Qt changed their policy - and requires to enter the login/password during the installation. To securely pass those creds
you can use the next way:

1. Create `secrets.env` file (you should already have the Qt account):
    ```
    export QT_CI_LOGIN='YOUR_EMAIL'
    export QT_CI_PASSWORD='YOUR_PASSWORD'
    ```
2. Run simple http server to serve the secrets.env file, for example execute python command in the same folder:
    ```
    $ python -m SimpleHTTPServer 8765
    ```
3. Check the file is available:
    ```
    $ curl http://0.0.0.0:8765/secrets.env
    ```
4. While http server is running - run the docker build command (you can check the docker network to get the host IP):
    ```
    $ cd 5.14-android
    $ docker build --rm=true --build-arg 'QT_CI_ENV_URL=http://172.17.0.1:8765/secrets.env' -t YOUR_LOGIN/qt:$(basename "${PWD}") .
    ```
5. Done - your Qt image is ready.

## Links

Used extract-qt script from https://github.com/benlau/qtci/blob/master/bin/extract-qt-installer
