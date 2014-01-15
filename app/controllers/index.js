$.index.open();


xhr("http://api.civicapps.org/restaurant-inspections", "GET", {}, function(result) {
	console.log(result);
	// $.label.text = JSON.stringify(result);
	
	var rows = [];
	_.each(result.results, function(item) {
		rows.push(Alloy.createController('row', {
            data: item.name + ': ' + item.score
        }).getView());
	});
	$.table.setData(rows);
});