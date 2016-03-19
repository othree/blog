
all: stylesheets/all.css.br stylesheets/all.css.gz scripts/all.js.br scripts/all.js.gz

stylesheets/all.css.br: stylesheets/all.css
	bro --force --input stylesheets/all.css --output stylesheets/all.css.br

stylesheets/all.css.gz: stylesheets/all.css
	zopfli stylesheets/all.css

stylesheets/all.css: stylesheets/othree.min.css
	cat stylesheets/pure-min.css stylesheets/grids-responsive-min.css stylesheets/othree.min.css > stylesheets/all.css

stylesheets/othree.min.css:
	cleancss stylesheets/othree.css > stylesheets/othree.min.css

scripts/all.js.br: scripts/all.js
	bro --force --input scripts/all.js --output scripts/all.js.br

scripts/all.js.gz: scripts/all.js
	zopfli scripts/all.js

scripts/all.js:
	uglifyjs scripts/detect_cleartype.js scripts/device-pixel-ratio.js scripts/nav-search.js scripts/disable_pointer_events.js scripts/googleanalytic.js > scripts/all.js
