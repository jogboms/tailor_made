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
echo "Skipped google services configuration for $environment"
exit 0
fi

# Name and path of the resource we're copying
GOOGLESERVICE_INFO_PLIST=GoogleService-Info.plist
GOOGLESERVICE_INFO_FILE=${PROJECT_DIR}/Runner/Firebase/${environment}/${GOOGLESERVICE_INFO_PLIST}

# Make sure GoogleService-Info.plist exists
echo "Looking for ${GOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_FILE}"
if [ ! -f $GOOGLESERVICE_INFO_FILE ]
then
echo "No GoogleService-Info.plist found. Please ensure it's in the proper directory."
exit 1
fi

# Get a reference to the destination location for the GoogleService-Info.plist
# This is the default location where Firebase init code expects to find GoogleServices-Info.plist file
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
PLIST_DESTINATION_LOCAL="${PROJECT_DIR}/Runner/GoogleService-Info.plist"
echo "Will copy ${GOOGLESERVICE_INFO_PLIST} to final destination: ${PLIST_DESTINATION} and ${PLIST_DESTINATION_LOCAL}"

# Copy over the prod GoogleService-Info.plist for Release builds
cp "${GOOGLESERVICE_INFO_FILE}" "${PLIST_DESTINATION}"
cp "${GOOGLESERVICE_INFO_FILE}" "${PLIST_DESTINATION_LOCAL}"

# Copy over generated firebase_app_id_file.json for environment
FIREBASE_APP_ID_FILE=firebase_app_id_file
cp "${PROJECT_DIR}/${FIREBASE_APP_ID_FILE}.${environment}.json" "${PROJECT_DIR}/${FIREBASE_APP_ID_FILE}.json"
