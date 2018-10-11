HAZELCAST_VERSION=3.10.4
HAZELCAST_MEMBER_REV=1

DIST=build/dist
HZ_BIN=${DIST}/bin
HZ_ETC=${DIST}/etc

.PHONY: all clean cleanall cleandist download dist package ee

all: download package

ee: ee-download all

clean: cleandist
	# cleaning up local maven repo
	rm -fr build/mvnw

cleanall:
	# cleaning up everything
	rm -fr build
	rm -f archive/hazelcast-member-${HAZELCAST_VERSION}.${HAZELCAST_MEMBER_REV}.tar.gz

cleandist:
	# cleaning up dist
	rm -fr ${DIST}

dist:
	# copying docs and scripts
	mkdir -p ${DIST}
	mkdir -p ${HZ_BIN}
	mkdir -p ${HZ_ETC}/hazelcast
	cp README-Running.txt ${DIST}/README.txt
	cp hazelcast.xml ${HZ_ETC}/hazelcast
	cp src/hazelcast-member ${HZ_BIN}
	cp src/*.sh ${HZ_BIN}
	for f in ${HZ_BIN}/* ; do sed -i '.bak' 's/$${hazelcast_version}/${HAZELCAST_VERSION}/g' $$f ; done
	rm -f ${HZ_BIN}/*.bak
	chmod +x ${HZ_BIN}/*

download:
	# downloading Hazelcast artifacts
	HAZELCAST_VERSION=${HAZELCAST_VERSION} ./dl-artifacts.sh

ee-download:
	# downloading Hazelcast artifacts
	HAZELCAST_VERSION=${HAZELCAST_VERSION} ./ee-dl-artifacts.sh

package: dist
	# creating package
	mkdir -p archive
	tar -zcf archive/hazelcast-member-${HAZELCAST_VERSION}.${HAZELCAST_MEMBER_REV}.tar.gz -C ${DIST} README.txt bin lib etc
	@echo "Archive archive/hazelcast-member-${HAZELCAST_VERSION}.${HAZELCAST_MEMBER_REV}.tar.gz created successfully"
