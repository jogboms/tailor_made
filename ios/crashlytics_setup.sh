#!/bin/sh

# Regex to extract the scheme name from the Build Configuration
# For eg.
# If CONFIGURATION="Prod-Debug", then environment will get set to "prod".
environment="default"
if [[ $CONFIGURATION =~ ([A-Za-z]*)[-$] ]]; then
environment=$(echo ${BASH_REMATCH[1]} | tr 'A-Z' 'a-z')
fi
echo $environment

if [ "$environment" == "mock" ]; then
echo "Skipped crashlytics configuration for $environment"
exit 0
fi

${PODS_ROOT}/FirebaseCrashlytics/run
