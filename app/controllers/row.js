var args = arguments[0] || {};

$.data.text = args.data;

function getScore(e) {
    alert($.data.text);
}
