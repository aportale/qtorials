// ==UserScript==
// @name           qtdownload
// @namespace      http://qt.nokia.com/downloads
// @include        http://qt.nokia.com/downloads
// ==/UserScript==

renamings = new Array(
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td[2]/ul[2]/li/a',
		'Download Qt libraries 4.6 for Windows (176 MB)',
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td[2]/ul[2]/li[2]/a',
		'Download Qt libraries 4.6 for Linux/X11(130 MB)',
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td[2]/ul[2]/li[3]/a',
		'Download Qt libraries 4.6 for Mac (142 MB)',
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td[2]/ul[2]/li[4]/a',
		'Download Qt libraries 4.6 for embedded Linux (134 MB)',
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td[2]/ul[2]/li[5]/a',
		'Download Qt libraries 4.6 for the Symbian Platform (179 MB)',
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td[2]/ul[2]/li[5]/a/@href',
		'http://www.casaportale.de/temp/qt-symbian-opensource-4.6.0.exe',
	'/html/body/div/table/tbody/tr/td/div/div/div[2]/div/div/div[2]/div/div/div/table/tbody/tr[2]/td/ul[2]/li/a/@href',
		'http://www.casaportale.de/temp/qt-sdk-win-opensource-2009.05.exe'
);

for (i = 0; i < renamings.length / 2; i++) {
	var element = document.evaluate(renamings[i * 2], document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
	element.singleNodeValue.textContent = renamings[i * 2 + 1];
}
