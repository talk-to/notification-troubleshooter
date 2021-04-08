if [ -z "$1" ]; then
echo "Command line argument missing. Usage: ./localize.sh <PATH_TO_ASSETS_DIRECTORY>"
exit 1
fi

localizepath=$1/Localization/en.lproj
rm -f $localizepath/*.strings
find ../NotificationTroubleshooter  \( -name "*.swift" ! -name "UIConfiguration.swift" \) | xargs genstrings -o $localizepath -s NotificationTroubleshooterLocalizedString
sh utf-8-converter.sh $localizepath
sh generate-strings-from-xib.sh $1
sh utf-8-converter.sh $1/UserInterface
zip -rj $1/iOS-strings $localizepath/*
