
sudo bash ./installDependency.sh

git clone https://github.com/nemtech/catapult-server.git -b master --depth 1 \
  && cd catapult-server \
  && mkdir _build && cd _build \
  && cmake -DCMAKE_BUILD_TYPE=RelWithDebugInfo \
    -DCMAKE_CXX_FLAGS="-pthread" \
    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
    -DBSONCXX_LIB=/usr/local/lib/libbsoncxx.so \
    -DMONGOCXX_LIB=/usr/local/lib/libmongocxx.so \
    .. \
  && make publish && make -j4 && cd -


cd catapult-server \
  && patch -p1 < ../patch/config-user.patch \
  && mkdir -p seed/mijin-test \
  && mkdir data \
  && cd _build \
  && mv resources resources.bk \
  && cp -r ../resources . \
  && ./bin/catapult.tools.nemgen ../tools/nemgen/resources/mijin-test.properties \
  && cp -r ../seed/mijin-test/00000 ../data/
