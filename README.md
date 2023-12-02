# Usage

```bash
cd build
source ../src/prefix.sh
```

See all local packages that are available:
```bash
get_local_packages.sh | tee local_packages.txt
```

Build all local packages:
```bash
build_install_all.sh $(cat local_packages.txt)
```
You can use the environment variable `CMAKE_BUILD_PARALLEL_LEVEL` to control the number of parallel builds.

## build_install_all.sh
This script will build and install all packages passed as arguments in the correct order.
The following environment variables can be set to skip certain steps:
- `SKIP_FETCH`: skip fetching the PKGBUILD
- `SKIP_PATCH`: skip patching the PKGBUILD
- `SKIP_BUILD`: skip building the package

# Dependencies:
- devtools