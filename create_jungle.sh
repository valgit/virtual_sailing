#!/binbash
#script to create a generic jungle file

echo "creating Jungle file for current manifest"

cat <<EOF > jungle.txt
project.manifest = manifest.xml

# fix autobuild to a specific device
base.sourcePath=\$(vivoactive3.sourcePath)

# define the actual sourcePaths
EOF

for dev in $(grep 'iq:product id' manifest.xml | sed 's/.*iq:product id="\([^"]*\).*/\1/')
do 
   echo ${dev}.sourcePath=source\;source-${dev} >> jungle.txt
done

