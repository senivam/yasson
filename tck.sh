#!/bin/bash -x

export TCK_HOME='.'

TCK_NAME=jsonb-tck
TS_HOME=$TCK_HOME/$TCK_NAME

echo "Downloading JSON-B TCK tests"
wget -q http://download.eclipse.org/ee4j/jakartaee-tck/jakartaee8-eftl/promoted/eclipse-jsonb-tck-1.0.0.zip
echo "Exporting downloaded TCK tests"
unzip eclipse-jsonb-tck-*.zip -d ${TCK_HOME}

sed -i "s#^report.dir=.*#report.dir=$TCK_HOME/${TCK_NAME}report/${TCK_NAME}#g" ts.jte
sed -i "s#^work.dir=.*#work.dir=$TCK_HOME/${TCK_NAME}work/${TCK_NAME}#g" ts.jte
sed -i "s#jsonb\.classes=.*#jsonb.classes=$TCK_HOME/glassfish5/glassfish/modules/jakarta.json.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.json.bind-api.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.json.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.inject.jar:$TCK_HOME/glassfish5/glassfish/modules/jakarta.servlet-api.jar:$TCK_HOME/glassfish5/glassfish/modules/yasson.jar#" ts.jte

mkdir -p $TCK_HOME/${TCK_NAME}report/${TCK_NAME}
mkdir -p $TCK_HOME/${TCK_NAME}work/${TCK_NAME}

# ant config.vi
cd $TS_HOME/src/com/sun/ts/tests/
#ant deploy.all
ant run.all
echo "Test run complete"