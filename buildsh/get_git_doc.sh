#!/bin/bash
cd /share-rd/lixq/src || exit 1
for uri in docbook.sourceforge.net/release/xsl/current/html/docbook.xsl \
           docbook.sourceforge.net/release/xsl-ns/current/manpages/docbook.xsl \
           docbook.sourceforge.net/release/xsl/current/html/../common/entities.ent \
           docbook.sourceforge.net/release/xsl/current/html/../common/table.xsl; do
    [[ -f $uri ]] || wget -r -np -k -l 1 http://$uri
done
grep --include='*.xsl' -R 'xsl:include href=' | while read -r line; do
    d=$(dirname "$(echo "$line" | awk '{print $1}')")
    f=$(echo "$line" | grep -o 'href=".*"' | awk -F '"' '{print $2}')
    uri=$d/$f
    [[ -f "$uri" ]] || wget -r -np -k -l 1 "http://$uri"
done
