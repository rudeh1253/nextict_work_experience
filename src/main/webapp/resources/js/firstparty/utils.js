/**
 * @param money{number | string}
 * @param delimiter{string}
 * @returns {string}
 */
function toFormattedMoneyRepresentation(money, delimiter = ",") {
	const val = new String(money);
	
	let last = val.length;
			
	let arr = [];
	while (last > 0) {
		arr.unshift(val.substring(last - 3, last));
		last -= 3;
	}
	
	return arr.join(delimiter);
}

function setInputFormatterForFormattedMoney(jElem) {
	jElem.on("keyup change", function(e) {
		if (!new RegExp("^(\\d{1,3}(,\\d{3})*)?$").test(e.target.value)) {
			const val = e.target.value.replaceAll(new RegExp("[^0-9]", "g"), "");
			e.target.value = toFormattedMoneyRepresentation(val);
		}
	});
}

function setInputFormatterForTravelTime(jElem, initValue, beforeNoon, afternoon) {
	const prevStateHolder = {
		prevState: initValue
	};
	const regex = new RegExp(
		`^(${beforeNoon}|${afternoon}) \\d{2}:\\d{2}$`
	);
	jElem.on("keyup change", function(e) {
		if (!regex.test(e.target.value)) {
			e.target.value = prevStateHolder.prevState;
		} else {
			const [noon, hourAndMinute] = e.target.value.split(" ");
			const [hour, minute] = hourAndMinute.split(":");
			console.log(noon);
			console.log(hour);
			console.log(minute);
		}
		prevStateHolder.prevState = e.target.value;
	});
}