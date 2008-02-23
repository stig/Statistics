# Project name from the X.xcodeproj directory
PROJ    = $(subst .xcodeproj,,$(wildcard *.xcodeproj))

# Marketing version
VERS    = $(strip $(shell agvtool mvers -terse1))

DIST    = $(PROJ)_$(VERS)
DMG     = $(DIST).dmg
DMGURL  = http://code.brautaset.org/$(PROJ)/files/$(DMG)
CONF    = Release

OBJPATH = /tmp/build/$(CONF)/$(PROJDIR)
LIB     = $(OBJPATH)/$(PROJ)


FWKPATH = /tmp/Frameworks/$(PROJ).framework

DOCS    = $(shell find Documentation -type f)
SRC     = $(shell find Classes -type f)

site: _site

_site: $(DOCS) $(SRC)
	-rm -rf _site
	doxygen Documentation/Doxyfile
	find _site -type f | xargs perl -pi -e 's{__DMGURL__}{$(DMGURL)}g'
	find _site -type f | xargs perl -pi -e 's{__VERSION__}{$(VERS)}g'

upload-site: _site
	curl --head $(DMGURL) 2>/dev/null | grep -q "200 OK" 
	rsync -ruv --delete _site/ --exclude files stig@brautaset.org:code/$(PROJ)/


dmg: $(DMG)

$(DMG): $(SRC) _site
	-rm $(DMG)
	-chmod -R +w $(DIST)    && rm -rf $(DIST)
	-chmod -R +w $(FWKPATH) && rm -rf $(FWKPATH)
	xcodebuild -configuration $(CONF) -target $(PROJ) install
	mkdir $(DIST)
	cp -p -R $(FWKPATH) $(DIST)
	cp -p -R _site $(DIST)/Documentation
	cat Documentation/redirect.js > $(DIST)/Documentation.html
	hdiutil create -fs HFS+ -volname $(DIST) -srcfolder $(DIST) $(DMG)

upload-dmg: $(DMG)
	curl --head $(DMGURL) 2>/dev/null | grep -q "404 Not Found" || false
	scp $(DMG) stig@brautaset.org:code/$(PROJ)/files/$(DMG)


