#!/usr/bin/env bash

set -uxeo pipefail

sdk_version=${sdk_version:-3.0.7}
sdk_release=${sdk_release:-2018-12-17-efeb3e3}
sdk_sha256=${sdk_sha256:-8c52ff7da0f9e6d88913af7c12353a7ea05973c15587da375600de3aba2a3add}
sdk_url=${sdk_url:-https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${sdk_version}-${sdk_release}.zip}
#https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.0.7-2018-12-17-efeb3e3.zip
sdk_dir=${sdk_dir:-./build/sdks}

# download and verify sdk
mkdir -p $sdk_dir
cd $sdk_dir
if [[ ! -e ./$sdk_version ]]; then
  curl -o connectiq-sdk.zip --user-agent travis-ci/gncc "$sdk_url"
  sha256sum connectiq-sdk.zip | grep $sdk_sha256
  unzip -qq -d ./$sdk_version connectiq-sdk.zip
fi

# temp developer keys for build
cd ..
if [[ ! -e ./keys ]]; then
  mkdir -p ./keys
  openssl genrsa \
    -out ./keys/developer_key.pem \
    4096
  openssl pkcs8 \
    -topk8 \
    -inform PEM \
    -outform DER \
    -in ./keys/developer_key.pem \
    -out ./keys/developer_key.der \
    -nocrypt
fi
cd ..

