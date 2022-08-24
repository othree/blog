
all: stylesheets/all.css.br stylesheets/all.css.gz scripts/all.js.br scripts/all.js.gz scripts/prism.js.br scripts/prism.js.gz

stylesheets/all.css.br: stylesheets/all.css
	bro --force --input stylesheets/all.css --output stylesheets/all.css.br

stylesheets/all.css.gz: stylesheets/all.css
	zopfli stylesheets/all.css

stylesheets/all.css: stylesheets/othree.min.css stylesheets/prism.min.css stylesheets/prism.dark.min.css
	cat stylesheets/pure-min.css stylesheets/grids-responsive-min.css stylesheets/prism.min.css stylesheets/prism.dark.min.css stylesheets/othree.min.css > stylesheets/all.css

stylesheets/othree.min.css: stylesheets/othree.css 
	cleancss stylesheets/othree.css > stylesheets/othree.min.css

stylesheets/prism.min.css: stylesheets/prism.css 
	cleancss stylesheets/prism.css > stylesheets/prism.min.css

stylesheets/prism.dark.min.css: stylesheets/prism.dark.css 
	cleancss stylesheets/prism.dark.css > stylesheets/prism.dark.min.css

scripts/all.js.br: scripts/all.js
	bro --force --input scripts/all.js --output scripts/all.js.br

scripts/all.js.gz: scripts/all.js
	zopfli scripts/all.js

scripts/prism.js.br: scripts/prism.js
	bro --force --input scripts/prism.js --output scripts/prism.js.br

scripts/prism.js.gz: scripts/prism.js
	zopfli scripts/prism.js

scripts/all.js: scripts/detect_cleartype.js scripts/device-pixel-ratio.js scripts/nav-search.js scripts/googleanalytic.js
	uglifyjs scripts/detect_cleartype.js scripts/device-pixel-ratio.js scripts/nav-search.js scripts/googleanalytic.js > scripts/all.js
