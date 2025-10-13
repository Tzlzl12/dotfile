``` shell
 cmake -B build/local                      \
    -DMATPLOTPP_BUILD_EXAMPLES=OFF                  \
    -DMATPLOTPP_BUILD_SHARED_LIBS=ON                \
    -DMATPLOTPP_BUILD_TESTS=OFF                     \
    -DCMAKE_BUILD_TYPE=Release            \
    -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -DBUILD_SHARED_LIBS=ON

cmake --build build/local -j 
cmake --install build/local
```

