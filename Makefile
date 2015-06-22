build: lenny-build

publish: lenny-publish

clean: lenny-clean

lenny-build:
	make -C src/lenny/ build

lenny-publish:
	make -C src/lenny/ publish

lenny-clean:
	make -C src/lenny/ clean

.PHONY: build publish clean lenny-build lenny-publish lenny-clean
