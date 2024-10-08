$j(document).ready(function() {
	updatePatterns();
	
	$j("#patternDeletionButton").on("click", function() {
		const checkeds = [];
		$j(".patternDeletionCheckbox")
				.filter((idx, e) => $j(e).prop("checked"))
				.each((idx, e) => checkeds.push(parseInt($j(e).data("idx"))));
				
		checkeds.sort(function(n1, n2) {
			return n1 - n2;
		});
		
		for (let i = 0; i < checkeds.length; i++) {
			patterns.splice(checkeds[i], 1);
			for (let j = i + 1; j < checkeds.length; j++) {
				checkeds[j]--;
			}
		}
		
		updatePatterns();
	});
});

function updatePatterns() {
	const exhibitionPatternTable = $j("#exhibitionPatternTable");
	exhibitionPatternTable.children().remove();
	exhibitionPatternTable.append($j(`
			<tr>
				<td></td>
				<td>${literals.exhibitionName}</td>
				<td>${literals.patternType}</td>
				<td>${literals.patternOrder}</td>
				<td>${literals.isPatternDisplayed}</td>
			</tr>
	`));
	
	if (patterns.length === 0) {
		exhibitionPatternTable.append($j(`
			<tr align="center">
				<td colspan="5">${literals.noPatternRegistered}</td>
			</tr
		`));
	}
	
	patterns.forEach(function(e, idx) {
		const name = e.exhibitionName;
		const order = e.patternOrder;
		const selection = e.patternTypeSelection;
		const selectionText = patternTypeSelections[e.patternTypeSelection];
		const displayedChecked = e.isPatternDisplayed ? "checked" : ""
		const patternRowHtml = `
				<tr>
					<td><input type="checkbox" data-idx="${idx}" class="patternDeletionCheckbox"></td>
					<td class="exName">${name}</td>
					<td class="patternTypeSelection" data-selection-value="${selection}">${selectionText}</td>
					<td>${order}</td>
					<td><input class="patternDisplayCheckbox" type="checkbox" ${displayedChecked}></td>
				</tr>
		`;
		
		const jPattern = $j(patternRowHtml);
		attachEventsToPattern(jPattern, idx, patterns);
		
		exhibitionPatternTable.append(jPattern);
	});
}

function attachEventsToPattern(jPattern, idx, patterns) {
	const patternDisplayCheckbox = jPattern.find(".patternDisplayCheckbox");
	patternDisplayCheckbox.on("change", function() {
		patterns[idx].isPatternDisplayed = patternDisplayCheckbox.prop("checked");
	});
	
	jPattern.find(".exName").on("click", function() {
		setPatternSelectionIdx(idx);
		updatePatternDetail();
	});
}