
all: stylesheets/all.css.br stylesheets/all.css.gz scripts/all.js.br scripts/all.js.gz scripts/prism.js.br scripts/prism.js.gz

stylesheets/all.css.br: stylesheets/all.css
	brotli --force -o stylesheets/all.css.br stylesheets/all.css 

stylesheets/all.css.gz: stylesheets/all.css
	zopfli stylesheets/all.css

stylesheets/all.css: stylesheets/othree.min.css stylesheets/prism.min.css stylesheets/prism.dark.min.css
	cat stylesheets/othree.min.css > stylesheets/all.css

stylesheets/othree.min.css: stylesheets/othree.css 
	uglifycss stylesheets/othree.css > stylesheets/othree.min.css

stylesheets/prism.min.css: stylesheets/prism.css 
	uglifycss stylesheets/prism.css > stylesheets/prism.min.css

stylesheets/prism.dark.min.css: stylesheets/prism.dark.css 
	uglifycss stylesheets/prism.dark.css > stylesheets/prism.dark.min.css

scripts/all.js.br: scripts/all.js
	brotli --force -o scripts/all.js.br scripts/all.js

scripts/all.js.gz: scripts/all.js
	zopfli scripts/all.js

scripts/prism.js.br: scripts/prism.js
	brotli --force -o scripts/prism.js.br scripts/prism.js

scripts/prism.js.gz: scripts/prism.js
	zopfli scripts/prism.js

scripts/all.js: scripts/detect_cleartype.js scripts/device-pixel-ratio.js scripts/nav-search.js scripts/share.js
	uglifyjs scripts/detect_cleartype.js scripts/device-pixel-ratio.js scripts/nav-search.js scripts/share.js > scripts/all.js
