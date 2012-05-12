#!/bin/sh

TMP=/tmp/
SRC=$1
PAYLOAD=${TMP}Payload/
MIMETYPE=mimetype
METAINF=META-INF/
OEBPS=OEBPS/
CONTENT="${OEBPS}"content.opf
ITUNES=/Applications/iTunes.app
BOOKS="${HOME}"/Music/iTunes/iTunes\ Media/

checkFileOrDirectory()
{
	if [ ! -e "$1" ];
	then
		echo "$1" ': No such file or directory'
		deleteFileOrDirectory "$2"
		exit
	fi
}

deleteFileOrDirectory()
{
	if [ -f "$1" -o -d "$1" ];
	then
		rm -rf "$1"
	fi
}

checkFileOrDirectory "$SRC"
DST=`basename "${SRC}" | sed -e "s/ipa$/epub/"`
unzip -oq "${SRC}" -d "${TMP}"
checkFileOrDirectory "${PAYLOAD}"
BOOK="${PAYLOAD}"`ls "${PAYLOAD}"`/book/
checkFileOrDirectory "${BOOK}" "${PAYLOAD}"
cd "${BOOK}"
cp "${CONTENT}" "${CONTENT}".tmp
sed -e "s/\(<\(dc\):\(language\)[^>]*>\)[^<]*\(<\/\2:\3>\)/\1ja\4/" "${CONTENT}".tmp > "${CONTENT}"
deleteFileOrDirectory "${CONTENT}".tmp
ditto -ck "${BOOK}" "${BOOKS}""${DST}"
checkFileOrDirectory "${BOOKS}""${DST}" "${PAYLOAD}"
open -a "${ITUNES}" "${BOOKS}""${DST}"
cd
deleteFileOrDirectory "${PAYLOAD}"
exit
