function updateProductRegistrationTable(productIndicesSet) {
	const productIndices = [];
	for (let i of productIndicesSet) {
		productIndices.push(i);
	}
	productIndices.sort((n1, n2) => n1 - n2);
	
	const productRegistrationTable = $j("#productRegistrationTable");
	productRegistrationTable.children().remove();
	productRegistrationTable.append($j(`
		<tr>
			<td></td>
			<td>${texts.productName}</td>
			<td>${texts.price}</td>
			<td>${texts.isDisplayed}</td>
		</tr>
	`));
	for (let productIdx of productIndices) {
		const product = productInfos[productIdx];
		const jRow = $j(`
			<tr class="productRegistrationRow" data-product-idx="${productIdx}">
				<td><input class="productRegistrationDeleteCheckbox" data-product-idx="${productIdx}" type="checkbox"></td>
				<td>${product.productName}</td>
				<td>${toFormattedMoneyRepresentation(product.productPrice)}</td>
				<td><input class="productRegistrationView" type="checkbox" checked></td>
			</tr>
		`);
		productRegistrationTable.append(jRow);
	}
	
	if (productIndices.length === 0) {
		productRegistrationTable.append($j(`
				<tr>
					<td colspan="4">${texts.noProductRegistered}</td>
				</tr>
		`));
	}
}