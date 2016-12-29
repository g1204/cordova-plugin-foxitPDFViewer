var exec = require('cordova/exec');

exports.initLibrary = function(sn, key, success, error) {
    exec(success, error, "FoxitPDFViewer", "initLibrary", [sn, key]);
};

exports.openSamplePDF = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "openSamplePDF");
};

exports.loadExtensions = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "loadExtensions");
};

exports.closePDF = function(success, error) {
    exec(success, error, "FoxitPDFViewer", "closePDF");
};
