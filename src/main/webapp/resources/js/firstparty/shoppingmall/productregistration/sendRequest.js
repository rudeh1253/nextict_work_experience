function sendRequest() {
	const data = getRegistrationData();
	
	console.log(data);
	
	$j.ajax({
		url: "/shoppingmall/registerProduct.do",
		type: "POST",
		dataType: "json",
		contentType: "application/json",
		data: JSON.stringify(data),
		success: function(data, textStatus, jqXHR) {
			alert(texts.registrationSucceess);
			console.log(data);
		},
		error: function(jqXHR, textStatus, errorThrown) {
			alert(texts.fail);
			console.error(textStatus);
			console.error(jqXHR);
			console.error(errorThrown);
		}
	});
}

function getRegistrationData() {
	const data = [];
	$j(".productRegistrationRow").each(function (idx, e) {
		const je = $j(e);
		const productIdx = je.data("product-idx");
		const isChecked = je.find(".productRegistrationView").prop("checked");
		data.push({
			productGroupIdx: productGroupIdx,
			productIdx: productIdx,
			productGroupProductView: isChecked
		});
	});
	return data;
}