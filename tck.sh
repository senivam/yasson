#!/bin/bash -x

export TCK_HOME=`pwd`

GF_BUNDLE_URL="central.maven.org/maven2/org/glassfish/main/distributions/glassfish/5.1.0/glassfish-5.1.0.zip"
TCK_NAME=jsonb-tck
TS_HOME=$TCK_HOME/$TCK_NAME

echo "Downloading JSON-B TCK tests"
wget -q http://download.eclipse.org/ee4j/jakartaee-tck/jakartaee8-eftl/promoted/eclipse-jsonb-tck-1.0.0.zip
echo "Exporting downloaded TCK tests"
unzip -qq eclipse-jsonb-tck-*.zip -d ${TCK_HOME}

echo "Downloading GlassFish "
wget -q --no-cache $GF_BUNDLE_URL -O latest-glassfish.zip
echo "Exporting downloaded GlassFish"
unzip -qq ${TCK_HOME}/latest-glassfish.zip -d ${TCK_HOME}

cp -a target/yasson.jar glassfish5/glassfish/modules/yasson.jar

cd $TS_HOME/bin

sed -i "s#^report.dir=.*#report.dir=$TCK_HOME/${TCK_NAME}report/${TCK_NAME}#g" ts.jte
sed -i "s#^work.dir=.*#work.dir=$TCK_HOME/${TCK_NAME}work/${TCK_NAME}#g" ts.jte
sed -i "s#jsonb\.classes=.*#jsonb.classes=$TCK_HOME/glassfish5/glassfish/modules/jakarta.json.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.json.bind-api.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.json.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.inject.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.servlet-api.jar:$TCK_HOME/glassfish5/glassfish/modules/yasson.jar#" ts.jte

mkdir -p $TCK_HOME/${TCK_NAME}report/${TCK_NAME}
mkdir -p $TCK_HOME/${TCK_NAME}work/${TCK_NAME}

# ant config.vi
cd $TS_HOME/src/com/sun/ts/tests/
#ant deploy.all
ant run.all | tee ${TCK_HOME}/result.log
export FAILED_COUNT=`grep -c "Finished Test:  FAILED" ${TCK_HOME}/result.log`

if [ "${FAILED_COUNT}" -gt "0" ]
then
        echo "FAILED TCK TESTS FOUND"
        exit 1
else
        echo "TCK OK"
        exit 0
fi
