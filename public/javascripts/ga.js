var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl."
		: "http://www.");
document
		.write(unescape("%3Cscript src='"
				+ gaJsHost
				+ "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
try {
	var pageTracker = _gat._getTracker("UA-7218359-3");
	pageTracker._trackPageview();
} catch (err) {
}