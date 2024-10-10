const productIndicesInRegistrationTable = new Set();

$j(document).ready(function() {
	const productInfoTable = $j("#productInfoTable");
	for (let productIdx of Object.keys(productInfos)) {
		const newRowJQuery = $j(`
			<tr>
				<td><input type="checkbox" class="productAddCheckbox" data-product-idx="${productIdx}"></td>
				<td>${productInfos[productIdx].productName}</td>
				<td>${toFormattedMoneyRepresentation(productInfos[productIdx].productPrice)}</td>
			</tr>
		`);
		
		productInfoTable.append(newRowJQuery);
	}
	
	updateProductRegistrationTable(productIndicesInRegistrationTable);
	
	$j("#productAddButton").on("click", function() {
		mergeCheckedProducts(productIndicesInRegistrationTable, $j(".productAddCheckbox"), function (bucket, idx) {
			bucket.add(idx);
		});
	});
	
	$j("#productRegistrationDeleteButton").on("click", function() {
		mergeCheckedProducts(productIndicesInRegistrationTable, $j(".productRegistrationDeleteCheckbox"), function (bucket, idx) {
			bucket.delete(idx);
		}); 
	});
	
	$j("#saveButton").on("click", function() {
		sendRequest();
	})
});

function mergeCheckedProducts(productIndicesBucket, checkboxJQuery, setOperation) {
	const checked = new Set();
	checkboxJQuery.filter((idx, e) => $j(e).prop("checked"))
			.each((idx, e) => checked.add($j(e).data("product-idx")));
	for (let i of checked) {
		setOperation(productIndicesBucket, i);
	}
	updateProductRegistrationTable(productIndicesBucket); 
}