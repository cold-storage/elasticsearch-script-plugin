#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"
cd ..
cp build/libs/elasticsearch-script-plugin-IGNORE_VERSION.jar build/elasticsearch-script-plugin.jar
cp misc/plugin-descriptor.properties build
cd build
zip elasticsearch-script-plugin.zip elasticsearch-script-plugin.jar plugin-descriptor.properties
