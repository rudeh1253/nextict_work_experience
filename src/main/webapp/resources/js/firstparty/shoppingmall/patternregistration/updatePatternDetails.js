let selectedPatternIdx = -1;

function setPatternSelectionIdx(idx) {
	selectedPatternIdx = idx;
}

$j(document).ready(function() {
	$j("#detailInsertionButton").on("click", function() {
		patterns[selectedPatternIdx].patternDetails.push({
			detailType: Object.keys(detailTypes)[0],
			detailImage: null,
			detailText: "",
			detailMovie: "",
			isPatternDisplayed: true
		});
		
		updatePatternDetail();
	});
	
	$j("#detailDeletionButton").on("click", function() {
		const checkeds = [];
		console.log("here");
		$j(".detailDeletionCheckbox").filter((idx, e) => $j(e).prop("checked"))
				.each((idx, e) => checkeds.push(parseInt($j(e).data("idx"))));
				
		console.log(checkeds);
				
		checkeds.sort(function(n1, n2) {
			return n1 - n2;
		});
		
		for (let i = 0; i < checkeds.length; i++) {
			patterns[selectedPatternIdx].patternDetails.splice(checkeds[i], 1);
			for (let j = i + 1; j < checkeds.length; j++) {
				checkeds[j]--;
			}
		}
		
		updatePatternDetail();
	});
});

function updatePatternDetail() {
	const patternDetails = patterns[selectedPatternIdx].patternDetails;
	if (!patternDetails) {
		console.error("patternDetails is undefined");
		return;
	}
	const detailTable = $j("#exhibitionPatternDetailTable");
	detailTable.children().remove();
	detailTable.append($j(`
			<tr>
				<td></td>
				<td>${literals.patternDetailType}</td>
				<td>${literals.patternDetailImage}</td>
				<td>${literals.patternDetailText}</td>
				<td>${literals.patternDetailMovie}</td>
				<td>${literals.isPatternDisplayed}</td>
			</tr>
	`));
	
	if (patternDetails.length === 0) {
		detailTable.append(`
				<tr>
					<td colspan="6">${literals.noPatternDetails}</td>
				</tr>
		`);
	}
	
	patternDetails.forEach(function(e, idx) {
		const detailType = e.detailType;
		const detailImage = e.detailImage;
		const detailText = e.detailText;
		const detailMovie = e.detailMovie;
		const isPatternDisplayed = e.isPatternDisplayed;
		const displayChecked = isPatternDisplayed ? "checked" : "";
		
		const jDetail = $j(`
			<tr>
				<td><input type="checkbox" data-idx="${idx}" class="detailDeletionCheckbox"></td>
				<td>
					<select class="detailTypeSelect">
						${Object.keys(detailTypes).map(function(e) {
							const selected = detailType === e ? "selected" : "";
							return `<option value="${e}" ${selected}>${detailTypes[e]}</option>`
						}).join(" ")}
					</select>
				</td>
				<td>
					<input type="file" accept="image/png, image/jpeg, image/jpg, image/webp" class="imageFile">
				</td>
				<td><input class="detailTextInput" type="text" value="${detailText}"></td>
				<td><input class="detailMovieInput" type="text" value="${detailMovie}"></td>
				<td><input class="detailPatternDisplayCheckbox" type="checkbox" ${displayChecked}></td>
			</tr>
		`);
		
		jDetail.find(".imageFile").get(0).files = detailImage;
	
		attachEventsToDetail(jDetail, idx, patternDetails);
		
		detailTable.append(jDetail);
	});
}

function attachEventsToDetail(jDetail, idx, patternDetails) {
	jDetail.find(".detailTypeSelect").on("change", function(e) {
		patternDetails[idx].detailType = $j(e.target).val();
	});
	
	jDetail.find(".imageFile").on("change", function(e) {
		patternDetails[idx].detailImage = e.target.files;
	});
	
	jDetail.find(".detailTextInput").on("change", function(e) {
		patternDetails[idx].detailText = e.target.value;
	});
	
	jDetail.find(".detailMovieInput").on("change", function(e) {
		patternDetails[idx].detailMovie = e.target.value;
	});
	
	jDetail.find(".detailPatternDisplayCheckbox").on("change", function(e) {
		const checked = $j(e.target).prop("checked");
		patternDetails[idx].isPatternDisplayed = checked;
	});
}