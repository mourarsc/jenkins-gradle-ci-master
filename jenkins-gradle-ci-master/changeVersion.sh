#/bin/bash
sed -i "s/VERSION_APP/$(cat gradle.properties | grep -i version | cut -d'=' -f2)/g" deploy.yml