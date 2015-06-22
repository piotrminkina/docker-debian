build: build.done

build.done: rootfs.tar.xz
	docker build -t piotrminkina/debian:lenny -t piotrminkina/debian:5.0 .
	touch build.done

publish: build
	docker push piotrminkina/debian:lenny
	docker push piotrminkina/debian:5.0

clean:
	docker rmi -f piotrminkina/debian:lenny piotrminkina/debian:5.0 || /bin/true
	rm -rf build.done rootfs.done rootfs/ rootfs.tar.xz

rootfs.tar.xz: rootfs.done
	tar -cJf rootfs.tar.xz -C rootfs/ .

rootfs.done:
	rm -rf rootfs/
	
	debootstrap --arch=amd64 --components=main,contrib,non-free --variant=minbase lenny rootfs/ http://archive.debian.org/debian
	
	echo "deb http://archive.debian.org/debian-volatile lenny/volatile main contrib non-free" >> rootfs/etc/apt/sources.list
	echo "deb http://archive.debian.org/debian-security lenny/updates main contrib non-free" >> rootfs/etc/apt/sources.list
	echo "Acquire::Check-Valid-Until \"0\";" > rootfs/etc/apt/apt.conf.d/99allow-expired-keys
	
	chroot rootfs/ /bin/bash -c "export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get -yqq install apt-utils && apt-get -yqq --allow-unauthenticated dist-upgrade"
	
	find rootfs/var/cache/apt/archives/ rootfs/var/lib/apt/lists/ -type f | xargs rm -f
	
	touch rootfs.done

.PHONY: build publish clean
