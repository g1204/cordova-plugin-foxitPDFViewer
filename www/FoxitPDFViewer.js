var exec = require('cordova/exec');

exports.initLibrary = function(sn, key, success, error) {
    exec(success, error, "FoxitPDFViewer", "initLibrary", [sn, key]);
};

exports.openSamplePDF = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "openSamplePDF");
};

exports.close = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "close");
};

exports.getPageCount = function(success, error) {
   exec(success, error, "FoxitPDFViewer", "getPageCount");
};
               
exports.gotoPage = function(page, success, error) {
   exec(success, error, "FoxitPDFViewer", "gotoPage", [page]);
};

exports.gotoNextPage = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "gotoNextPage");
};
               
exports.gotoPrevPage = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "gotoPrevPage");
};

// 0:single page 1:continuous 2:thumbnail
exports.setPageLayoutMode = function(mode, success, error) {
    exec(success, error, "FoxitPDFViewer", "setPageLayoutMode", [mode]);
};

