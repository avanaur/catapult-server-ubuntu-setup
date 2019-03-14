sed -i.bak -e "s%http://[^ ]\+%http://linux.yz.yamagata-u.ac.jp/ubuntu/%g" /etc/apt/sources.list
apt-get update -y && apt-get upgrade -y && apt-get clean && apt-get install -y --no-install-recommends \
  git \
  curl \
  wget \
  vim \
  autoconf \
  automake \
  apt-file \
  build-essential \
  software-properties-common \
  pkg-config \
  python3 \
  libc6-dev \
  libssl-dev \
  libsasl2-dev \
  libtool \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

add-apt-repository ppa:ubuntu-toolchain-r/test \
  && apt-get update && apt-get install -y --no-install-recommends gcc-7 g++-7 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && rm /usr/bin/gcc /usr/bin/g++ \
  && ln -s /usr/bin/gcc-7 /usr/bin/gcc \
  && ln -s /usr/bin/g++-7 /usr/bin/g++

git clone https://gitlab.kitware.com/cmake/cmake.git -b v3.11.1 --depth 1 \
  && cd cmake \
  && ./bootstrap --prefix=/usr/local && make -j4 && make install \
  && cd -

wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz \
  && tar -xzf boost_1_69_0.tar.gz && cd boost_1_69_0 \
  && ./bootstrap.sh && ./b2 toolset=gcc install --prefix=/usr/local -j4 \
  && cd - && rm boost_1_69_0.tar.gz && rm -rf boost_1_69_0.tar.gz

git clone https://github.com/google/googletest.git -b release-1.8.0 --depth 1 \
  && mkdir -p googletest/_build && cd googletest/_build \
  && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install \
  && cd -

git clone https://github.com/google/benchmark.git google.benchmark.git -b v1.4.1 --depth 1 \
  && cd google.benchmark.git && mkdir _build && cd _build \
  && cmake -DCMAKE_BUILD_TYPE=Release -DBENCHMARK_ENABLE_GTEST_TESTS=OFF .. && make -j4 && make install \
  && cd - && rm -rf google.benchmark.git

git clone https://github.com/facebook/rocksdb.git -b v5.12.4 --depth 1 \
  && mkdir -p rocksdb/_build && cd rocksdb/_build \
  && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install \
  && cd -

git clone https://github.com/zeromq/libzmq.git -b v4.2.3 --depth 1 \
  && mkdir -p libzmq/_build && cd libzmq/_build \
  && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install \
  && cd -

git clone https://github.com/zeromq/cppzmq.git -b v4.2.3 --depth 1 \
  && mkdir -p cppzmq/_build && cd cppzmq/_build \
  && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install \
  && cd -

git clone https://github.com/mongodb/mongo-c-driver.git mongo-c-driver.git -b 1.13.0 --depth 1 && cd mongo-c-driver.git \
  && mkdir _build && cd _build \
  && cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. \
  && make -j4 && make install \
  && cd - && rm -rf mongo-c-driver.git
#RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.4.2/mongo-c-driver-1.4.2.tar.gz \
#  && tar xzf mongo-c-driver-1.4.2.tar.gz && cd mongo-c-driver-1.4.2 \
#  && ./configure --disable-automatic-init-and-cleanup --prefix=/usr/local \
#  && make -j4 && make install \
#  && cd -

git clone https://github.com/mongodb/mongo-cxx-driver.git mongo-cxx-driver.git -b r3.4.0 --depth 1 && cd mongo-cxx-driver.git \
  && sed -i 's/kvp("maxAwaitTimeMS", count)/kvp("maxAwaitTimeMS", static_cast<int64_t>(count))/' src/mongocxx/options/change_stream.cpp \
  && mkdir _build && cd _build \
  && cmake -DLIBBSON_DIR=/usr/local -DBOOST_ROOT=~/boost-build-1.69.0 \
    -DLIBMONGOC_DIR=/usr/local -DBSONCXX_POLY_USE_BOOST=1 \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. \
  && make -j4 && make install \
  && cd - rm -rf mongo-cxx-driver.git
