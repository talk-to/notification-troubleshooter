for file in ../NotificationTroubleshooter/Assets/UserInterface/Base.lproj/*.xib  ../NotificationTroubleshooter/Assets/UserInterface/Base.lproj/*.storyboard; do
filename=$(basename "$file" ".xib")
echo $filename
stringsfile=$1/Localization/en.lproj/$filename.strings
ibtool $file --generate-strings-file $stringsfile
done
