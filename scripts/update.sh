#!/bin/sh
WHEREAMI="`pwd`"
CAFILE="startssl.pem"
JOPTS="-Djava.net.preferIPv4Stack=true"
echo "Updating freenet"

# Attempt to use the auto-fetcher code, which will check the sha1sums.

if test "$#" -gt 0
then
	if test "$1" = "testing"
	then
		RELEASE="testing"
		echo "WARNING! you're downloading an UNSTABLE snapshot version of freenet."
	else
		RELEASE="stable"
	fi
else
	RELEASE="stable"
fi

# We need to download the jars to temporary locations, check whether they are different,
# and if necessary shutdown the node before replacing, because java may do wierd things
# otherwise.

mkdir -p download-temp

if test -d download-temp
then
	echo Created temporary download directory.
	cp *.jar *.sha1 download-temp
else
	echo Could not create temporary download directory.
	exit
fi

# Bundle the CA
if test ! -f $CAFILE
then
# Delete the existing sha1test.jar: we want a new one to be downloaded
rm -f sha1test.jar
cat >$CAFILE << EOF
-----BEGIN CERTIFICATE-----
MIIHyTCCBbGgAwIBAgIBATANBgkqhkiG9w0BAQUFADB9MQswCQYDVQQGEwJJTDEW
MBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzEpMCcGA1UEAxMgU3RhcnRDb20gQ2VydGlmaWNh
dGlvbiBBdXRob3JpdHkwHhcNMDYwOTE3MTk0NjM2WhcNMzYwOTE3MTk0NjM2WjB9
MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzEpMCcGA1UEAxMgU3Rh
cnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUA
A4ICDwAwggIKAoICAQDBiNsJvGxGfHiflXu1M5DycmLWwTYgIiRezul38kMKogZk
pMyONvg45iPwbm2xPN1yo4UcodM9tDMr0y+v/uqwQVlntsQGfQqedIXWeUyAN3rf
OQVSWff0G0ZDpNKFhdLDcfN1YjS6LIp/Ho/u7TTQEceWzVI9ujPW3U3eCztKS5/C
Ji/6tRYccjV3yjxd5srhJosaNnZcAdt0FCX+7bWgiA/deMotHweXMAEtcnn6RtYT
Kqi5pquDSR3l8u/d5AGOGAqPY1MWhWKpDhk6zLVmpsJrdAfkK+F2PrRt2PZE4XNi
HzvEvqBTViVsUQn3qqvKv3b9bZvzndu/PWa8DFaqr5hIlTpL36dYUNk4dalb6kMM
Av+Z6+hsTXBbKWWc3apdzK8BMewM69KN6Oqce+Zu9ydmDBpI125C4z/eIT574Q1w
+2OqqGwaVLRcJXrJosmLFqa7LH4XXgVNWG4SHQHuEhANxjJ/GP/89PrNbpHoNkm+
Gkhpi8KWTRoSsmkXwQqQ1vp5Iki/untp+HDH+no32NgN0nZPV/+Qt+OR0t3vwmC3
Zzrd/qqc8NSLf3Iizsafl7b4r4qgEKjZ+xjGtrVcUjyJthkqcwEKDwOzEmDyei+B
26Nu/yYwl/WL3YlXtq09s68rxbd2AvCl1iuahhQqcvbjM4xdCUsT37uMdBNSSwID
AQABo4ICUjCCAk4wDAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCAa4wHQYDVR0OBBYE
FE4L7xqkQFulF2mHMMo0aEPQQa7yMGQGA1UdHwRdMFswLKAqoCiGJmh0dHA6Ly9j
ZXJ0LnN0YXJ0Y29tLm9yZy9zZnNjYS1jcmwuY3JsMCugKaAnhiVodHRwOi8vY3Js
LnN0YXJ0Y29tLm9yZy9zZnNjYS1jcmwuY3JsMIIBXQYDVR0gBIIBVDCCAVAwggFM
BgsrBgEEAYG1NwEBATCCATswLwYIKwYBBQUHAgEWI2h0dHA6Ly9jZXJ0LnN0YXJ0
Y29tLm9yZy9wb2xpY3kucGRmMDUGCCsGAQUFBwIBFilodHRwOi8vY2VydC5zdGFy
dGNvbS5vcmcvaW50ZXJtZWRpYXRlLnBkZjCB0AYIKwYBBQUHAgIwgcMwJxYgU3Rh
cnQgQ29tbWVyY2lhbCAoU3RhcnRDb20pIEx0ZC4wAwIBARqBl0xpbWl0ZWQgTGlh
YmlsaXR5LCByZWFkIHRoZSBzZWN0aW9uICpMZWdhbCBMaW1pdGF0aW9ucyogb2Yg
dGhlIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFBvbGljeSBhdmFp
bGFibGUgYXQgaHR0cDovL2NlcnQuc3RhcnRjb20ub3JnL3BvbGljeS5wZGYwEQYJ
YIZIAYb4QgEBBAQDAgAHMDgGCWCGSAGG+EIBDQQrFilTdGFydENvbSBGcmVlIFNT
TCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTANBgkqhkiG9w0BAQUFAAOCAgEAFmyZ
9GYMNPXQhV59CuzaEE44HF7fpiUFS5Eyweg78T3dRAlbB0mKKctmArexmvclmAk8
jhvh3TaHK0u7aNM5Zj2gJsfyOZEdUauCe37Vzlrk4gNXcGmXCPleWKYK34wGmkUW
FjgKXlf2Ysd6AgXmvB618p70qSmD+LIU424oh0TDkBreOKk8rENNZEXO3SipXPJz
ewT4F+irsfMuXGRuczE6Eri8sxHkfY+BUZo7jYn0TZNmezwD7dOaHZrzZVD1oNB1
ny+v8OqCQ5j4aZyJecRDjkZy42Q2Eq/3JR44iZB3fsNrarnDy0RLrHiQi+fHLB5L
EUTINFInzQpdn4XBidUaePKVEFMy3YCEZnXZtWgo+2EuvoSoOMCZEoalHmdkrQYu
L6lwhceWD3yJZfWOQ1QOq92lgDmUYMA0yZZwLKMS9R9Ie70cfmu3nZD0Ijuu+Pwq
yvqCUqDvr0tVk+vBtfAii6w0TiYiBKGHLHVKt+V9E9e4DGTANtLJL4YSjCMJwRuC
O3NJo2pXh5Tl1njFmUNj403gdy3hZZlyaQQaRwnmDwFWJPsfvw55qVguucQJAX6V
um0ABj6y6koQOdjQK/W/7HW/lwLFCRsI3FU34oH7N4RDYiDK51ZLZer+bMEkkySh
NOsF/5oirpt9P/FlUQqmMGqz9IgcgA38corog14=
-----END CERTIFICATE-----
EOF
fi

if test ! -x "`which wget`"
then
	WGET=0
	DOWNLOADER="curl --cacert $CAFILE -q -f -L -O "
else
	WGET=1
	DOWNLOADER="wget -o /dev/null --ca-certificate $CAFILE -N "
fi

if test ! -s sha1test.jar
then
	for x in 1 2 3 4 5
	do
		echo Downloading sha1test.jar utility jar which will download the actual update.
		$DOWNLOADER https://emu.freenetproject.org/sha1test.jar
		
		if test -s sha1test.jar
		then
			break
		fi
	done
	if test ! -s sha1test.jar
	then
		echo Could not download Sha1Test. The servers may be offline?
		exit
	fi
fi

if java $JOPTS -cp sha1test.jar Sha1Test update/update.sh ./ $CAFILE
then
	echo "Downloaded update.sh"
	chmod +x update.sh

	touch update.sh update2.sh
	if cmp update.sh update2.sh >/dev/null 2>&1
	then
		echo "Your update.sh is up to date"
	else
		cp update.sh update2.sh
		exec ./update.sh $RELEASE
		exit
	fi
else
	echo "Could not download new update.sh."
	exit
fi

if java $JOPTS -cp sha1test.jar Sha1Test freenet-$RELEASE-latest.jar download-temp $CAFILE
then
	echo Downloaded freenet-$RELEASE-latest.jar
else
	echo Could not download new freenet-$RELEASE-latest.jar.
	exit
fi

if java $JOPTS -cp sha1test.jar Sha1Test freenet-ext.jar download-temp $CAFILE
then
	echo Downloaded freenet-ext.jar
else
	echo Could not download new freenet-ext.jar.
	exit
fi

cat wrapper.conf | sed 's/freenet-cvs-snapshot/freenet/g' | sed 's/freenet-stable-latest/freenet/g' | sed 's/freenet.jar.new/freenet.jar/g' | sed 's/freenet-ext.jar.new/freenet-ext.jar/g' > wrapper2.conf
mv wrapper2.conf wrapper.conf

if test ! -x "`which cmp`"
then
	if test ! -x "`which md5sum`"
	then
		echo No cmp or md5sum utility detected
		echo Restarting the node as we cannot tell whether we need to.
		./run.sh stop
		mv download-temp/freenet-$RELEASE-latest.jar freenet-$RELEASE-latest.jar
		rm freenet.jar
		ln -s freenet-$RELEASE-latest.jar freenet.jar
		mv download-temp/freenet-ext.jar freenet-ext.jar
		./run.sh start
	else
		if test "`md5sum freenet.jar | cut -d ' ' -f1`" != "`md5sum download-temp/freenet-$RELEASE-latest.jar | cut -d ' ' -f1`"
		then
			echo Restarting node because freenet-$RELEASE-latest.jar updated.
			./run.sh stop
			mv download-temp/freenet-$RELEASE-latest.jar freenet-$RELEASE-latest.jar
			rm freenet.jar
			ln -s freenet-$RELEASE-latest.jar freenet.jar
			mv download-temp/freenet-ext.jar freenet-ext.jar
			./run.sh start
		elif test "`md5sum freenet-ext.jar | cut -d ' ' -f 1`" != "`md5sum download-temp/freenet-ext.jar | cut -d ' ' -f1`"
		then
			echo Restarting node because freenet-ext.jar updated.
			./run.sh stop
			mv download-temp/freenet-ext.jar freenet-ext.jar
			./run.sh restart
		else
			echo Your node is up to date.
		fi
	fi
else
	if cmp freenet.jar download-temp/freenet-$RELEASE-latest.jar
	then
		# freenet.jar is up to date
		if cmp download-temp/freenet-ext.jar freenet-ext.jar
		then
			echo Your node is up to date
		else
			echo Restarting node because freenet-ext.jar updated.
			./run.sh stop
			mv download-temp/freenet-ext.jar freenet-ext.jar
			./run.sh start
		fi
	else
		echo Restarting node because freenet-$RELEASE-latest.jar updated
		./run.sh stop
		mv download-temp/freenet-$RELEASE-latest.jar freenet-$RELEASE-latest.jar
		rm freenet.jar
		ln -s freenet-$RELEASE-latest.jar freenet.jar
		mv download-temp/freenet-ext.jar freenet-ext.jar
		./run.sh start
	fi
fi

rm -rf download-temp

cd $WHEREAMI
