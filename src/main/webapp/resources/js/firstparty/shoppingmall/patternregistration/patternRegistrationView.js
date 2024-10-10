const patternTypeSelections = {};

$j(document).ready(function() {
	const exhibitionIdx = $j("#exhibitionName").data("exhibition-idx");
	
	$j("#patternTypeSelection").children().each(function(idx, e) {
		const je = $j(e);
		patternTypeSelections[je.val()] = je.text();
	});
	
	$j("#addPatternButton").on("click", function() {
		if (!validate(patterns, $j("#patternOrder"))) {
			return;
		}
		
		const exhibitionName = $j("#exhibitionName").val();
		const patternTypeSelectionValue = $j("#patternTypeSelection").val();
		const patternOrder = parseInt($j("#patternOrder").val());
		const isPatternDisplayed = $j("#isPatternDisplayed").prop("checked");
		
		patterns.push({
			exhibitionName: exhibitionName,
			patternTypeSelection: patternTypeSelectionValue,
			patternOrder: patternOrder,
			isPatternDisplayed: isPatternDisplayed,
			patternDetails: []
		});
		
		updatePatterns();
	});
	
	$j("#patternOrder").on("keyup change", function(e) {
		if (new RegExp("[^0-9]").test(e.target.value)) {
			e.target.value = e.target.value.replaceAll("[^0-9]", "g");
		}
	});
	
	$j("#submitButton").on("click", function() {
		makeRequestBody([], 0, patterns);
		/*
		$j.ajax({
			url: "/shoppingmall/registerPatterns.do",
			type: "POST",
			enctype: "multipart/form-data"
		});*/
	});
});

function makeRequestBody(requestBody, idx, patterns) {
	if (idx >= patterns.length) {
		console.log(requestBody);
		console.log(JSON.stringify(requestBody));
		const productGroupIdx = $j("#exhibitionName").data("exhibition-idx");
		$j.ajax({
			url: `/shoppingmall/registerPatterns.do?productGroupIdx=${productGroupIdx}`,
			type: "POST",
			dataType: "json",
			contentType: "application/json;charset=euc-kr",
			data: JSON.stringify(requestBody),
			success: function(data, textStatus, jqXHR) {
				console.log(data);
				alert(literals.success);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				console.error(jqXHR);
				console.error(textStatus);
				console.error(errorThrown);
			}
		});
		return;
	}
	const elem = patterns[idx];
	const requestElem = {
		productPatternType: elem.patternTypeSelection,
		productPatternSort: elem.patternOrder,
		productView: elem.isPatternDisplayed,
		patternDetails: []
	};
	requestBody.push(requestElem);
	makeRequestDetail(requestElem.patternDetails, 0, idx, patterns[idx].patternDetails, requestBody, patterns)
}

function makeRequestDetail(details, idx, patternIdx, patternDetails, requestBody, patterns) {
	if (idx >= patternDetails.length) {
		makeRequestBody(requestBody, patternIdx + 1, patterns)
		return;
	}
	const elem = patternDetails[idx];
	const requestElem = {
		ptDetailType: elem.detailType,
		ptDetailImageName: "",
		ptDetailImageDataInBase64: null,
		ptDetailDesc: elem.detailText,
		ptDetailMovie: elem.detailMovie,
		ptDetailView: elem.isPatternDisplayed
	};
	if (elem.detailImage) {
		const fr = new FileReader();
		fr.onload = function(evt) {
			requestElem.ptDetailImageName = elem.detailImage[0].name;
			requestElem.ptDetailImageDataInBase64 = evt.target.result.substring("data:image/jpeg;base64,".length, evt.target.result.length - 1);
			details.push(requestElem);
			makeRequestDetail(details, idx + 1, patternIdx, patternDetails, requestBody, patterns);
		}
		fr.readAsDataURL(elem.detailImage[0]);
		return;
	}
	details.push(requestElem);
	makeRequestDetail(details, idx + 1, patternIdx, patternDetails, requestBody, patterns);
}

function validate(patterns, patternOrder) {
	console.log(patterns);
	if (patternOrder.val().length === 0) {
		alert(literals.pleaseInputPatternOrder);
		patternOrder.trigger("focus");
		return false;
	}
	
	const patternOrderVal = parseInt(patternOrder.val());
	
	console.log(patternOrderVal);
	
	if (isNaN(patternOrderVal)) {
		alert(literals.pleaseInputNumber);
		patternOrder.trigger("focus");
	}
	
	for (let pattern of patterns) {
		if (pattern.patternOrder === patternOrderVal) {
			alert(literals.pleaseLetNoDuplicatePatternOrderExist);
			patternOrder.trigger("focus");
			return false;
		}
	}
	return true;
}