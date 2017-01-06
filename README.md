# cordova-plugin-foxitPDFViewer

## Installation

    cordova plugin add cordova-plugin-foxitpdfviewer

    embed FoxitRDK.framework into your project

## Supported platforms(for now)

- iOS

## Example

    <button id='theBtn'>open sample PDF</button>

    document.getElementById('theBtn').onclick = function ()
    {
        var pdfViewer = cordova.plugins.FoxitPDFViewer;
        var sn = 'N/AX7ZuQjab0Cxf7MQ3P7VLnZCVs6aerDQKl70LhvXsTIlEbPxq76g==';
        var key = 'ezJvj83HvWp3NEt5JFl9RotbDgaOTdD414oOK2PgSZ7FjlX+D+tHZ4kSbhEjv3/HHVfZTiWtieJvJiQn5Pxe12FGM03bperbsMqtepvCJ0qHs0McHXqAWTeg7jK5qJI445fmxooqD6tTklCQot5UGsvXfUd8p29t3dBAIa84+o1R4QwnLf6ASOHpnf+j6sSBvzlU6yV4hYEwZzZBPGjMEG2jICe/Crsgl84UNJnvgLtf+qb0hbm2goWeCcdYxSkeSQ0eccgdVFJdNTXneWh0jZ7EXhyxoaoye/bru3gn5EuHaQZKcSLYBzZsuIp3OMnPyNK3hqvCg5KKGDif3koDrRCb/i3Lfy8+TINyF7Wp2XPjKHHVckNXjSxA29HNJy+Tmvc5n6mrtQA5XSNoaxUSOr8N5K5GIWi1urrJhgL/PmrGPUEQPESPPN8Au8DlEa36AMAo9GmRfFlsSbrK4FbJ6vgLP3+tpz6zQxh7iiGjyj2cOWD6vEQI07BU2mzQ/qZzZVXJVh5lFneyJkxBYHPO3Pxlc8XOiUbRo2NbP0xMLVL+oC+RmIv9cJMaP7iSn/46RsLL2CvNNsjWbk7bmzqYvztJ8BKqXeJtPhmyVYC6lPupA+v6/IaqM5f02V4wbiV3vuLHQE7Ws4wgF5sgMWku+v4Ecn0aoy35YYOLfD/L1HbRO3/9P/HHAtEfMTNY5KPEminLEkGLWRDHzO6R27Bbt+c4nQ1RzeF1Tet/m5+GPsjSjMKYA24DUXO3cZmgZrG1Czm4lPIzS/lW1fbWbDGNrITxN+qLOz/0spQxUR04sa9C1D/G7uF39U7JYXj5GHWgJ+GHyKOIvQr2VJnDKPBp73xoQvYgpGHe7ZwrlO5pUE2YPL1PU2UKxyoZTdyPaHjQ8HIUIgCg4+VlzKNmKA1+7ydyXbcyIczrTOf0ieOHgLTZsdbB7IavMphXAPxTGYJHVyd+QJNxhkr0WnxCjN0Seh1gozzy1V16A+VUjYLf3o1w1hzqPaYOk/L1UtXy5HNlFaUPncvXQ9c1vPU33AJWQ8kVxy5WOY2C2HsmCYT37hGWFwNDz9Voc0BWkwsIr7mz4zYAa9j47wzvBQWnUnOuIjdhApStaSwC7BGA8V2WLbBDos4xNDtDU1umUEu518lPY/NKOQpE0DAL9wcyXyUKJuzj3Zwgq2rqGv9uTvxhDMry7Flv/B+oNdkT+tVxgeokgQWwI2sr5Q==';
        pdfViewer.initLibrary(sn, key, function(successMsg) {
            pdfViewer.openSamplePDF(function(successMsg){
                pdfViewer.gotoPage(2);
                // ...
            }, alert);
        }, alert);
    }
