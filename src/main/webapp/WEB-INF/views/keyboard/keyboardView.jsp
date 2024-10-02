<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>가상키보드</title>

<script type="text/javascript" charset="euc-kr">
const firstConsonants = "ㄱ,ㄲ,ㄴ,ㄷ,ㄸ,ㄹ,ㅁ,ㅂ,ㅃ,ㅅ,ㅆ,ㅇ,ㅈ,ㅉ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ".split(",");

const vowels = [];

for (let i = "ㅏ".charCodeAt(0); i <= "ㅣ".charCodeAt(0); i++) {
	vowels.push(String.fromCharCode(i));
}

const finalConsonants = "ㄱ,ㄲ,ㄳ,ㄴ,ㄵ,ㄶ,ㄷ,ㄹ,ㄺ,ㄻ,ㄼ,ㄽ,ㄾ,ㄿ,ㅀ,ㅁ,ㅂ,ㅄ,ㅅ,ㅆ,ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ".split(",");
const allConsonants = [];

for (let i = "ㄱ".charCodeAt(0); i <= "ㅎ".charCodeAt(0); i++) {
	allConsonants.push(String.fromCharCode(i));
}

const assembledFinalConsonantOffsets = {
		1: {
			"ㅅ": 2
		},
		4: {
			"ㅈ": 1,
			"ㅎ": 2
		},
		8: {
			"ㄱ": 1,
			"ㅁ": 2,
			"ㅂ": 3,
			"ㅅ": 4,
			"ㅌ": 5,
			"ㅍ": 6,
			"ㅎ": 7
		},
		17: {
			"ㅅ": 1
		}
};

const latterConsonantOffsetInFirstConsonantLetter = {
		 3: 9,
		 5: 12,
		 6: 18,
		 9: 0,
		 10: 6,
		 11: 7,
		 12: 9,
		 13: 16,
		 14: 17,
		 15: 18,
		 18: 9
};

const vowelAssemblyOffset = {
		8: {
			"ㅏ": 1,
			"ㅐ": 2,
			"ㅣ": 3
		},
		13: {
			"ㅓ": 1,
			"ㅔ": 2,
			"ㅣ": 3
		},
		18: {
			"ㅣ": 1
		}
}

const firstConsonantLetterDissembly = {
		2: -2,
		4: -1,
		5: -2,
		9: -1,
		10: -2,
		11: -3,
		12: -4,
		13: -5,
		14: -6,
		15: -7,
		19: -2
}

const finalConsonantLetterDissemblyOffsets = {
		3: -2,
		5: -1,
		6: -2,
		9: -1,
		10: -2,
		11: -3,
		12: -4,
		13: -5,
		14: -6,
		15: -7,
		18: -1
}

const vowelDissemblyOffsets = {
		9: -1,
		10: -2,
		11: -3,
		14: -1,
		15: -2,
		16: -3,
		19: -1
}

function getCharacterOffset(letter) {
	if (isVowel(letter)) {
		return letter.charCodeAt(0) - "ㅏ".charCodeAt(0);
	}
	return isVowel(letter)
			? letter.charCodeAt(0) - "ㅏ".charCodeAt(0)
			: firstConsonants.indexOf(letter);
}

function getFinalConsonantLetterOffset(letter) {
	return finalConsonants.indexOf(letter);
}

function isVowel(letter) {
	const charCode = letter.charCodeAt(0);
	return charCode >= "ㅏ".charCodeAt(0) && charCode <= "ㅣ".charCodeAt(0);
}

function isFirstConsonant(character) {
	const charCode = character.charCodeAt(0);
	return charCode >= "ㄱ".charCodeAt(0) && charCode <= "ㅎ".charCodeAt(0);
}

function isNoFinalConsonant(character) {
	const charCode = character.charCodeAt(0);
	return charCode >= 0xAC00 && (charCode - 0xAC00) % 28 === 0;
}

function assemble(character, letter) {
	const charCode = character.charCodeAt(0);
	if (isFirstConsonant(character)) {
		if (isVowel(letter)) {
			const vowelOrder = getCharacterOffset(letter);
			return String.fromCharCode(0xAC00 + (getCharacterOffset(character) * 21 + vowelOrder) * 28);
		} else {
			return character + letter;
		}
	} else if (isVowel(character)) {
		if (isVowel(letter)) {
			const vowelIdx = vowelAssemblyOffset[charCode - "ㅏ".charCodeAt(0)];
			if (!vowelIdx) {
				return character + letter;
			}
			const increment = vowelIdx[letter];
			if (!increment) {
				return character + letter;
			}
			return String.fromCharCode(charCode + increment);
		}
		return character + letter;
	} else {
		const charOffset = charCode - 0xAC00
		if (isNoFinalConsonant(character)) {
			if (isVowel(letter)) {
				const vowelIdx = vowelAssemblyOffset[(charOffset / 28) % 21];
				if (!vowelIdx) {
					return character + letter;
				}
				const increment = vowelIdx[letter];
				if (!increment) {
					return character + letter;
				}
				return String.fromCharCode(charCode + increment * 28);
			}
			
			if (finalConsonants.indexOf(letter) === -1) {
				return character + letter;
			}
			
			return String.fromCharCode(charCode + getFinalConsonantLetterOffset(letter) + 1);
		} else {
			if (isVowel(letter)) {
				
				const finalConsonantOffset = charOffset % 28;
				
				const firstConsonanOffsetToBeNextCharacter = latterConsonantOffsetInFirstConsonantLetter[finalConsonantOffset];
				if (firstConsonanOffsetToBeNextCharacter !== undefined) {
					return deleteSingleLetter(character) + assemble(firstConsonants[firstConsonanOffsetToBeNextCharacter], letter);
				}
				
				return String.fromCharCode(charCode - charOffset % 28) + assemble(finalConsonants[charOffset % 28 - 1], letter);
			}
			
			const finalConsonantLetter = assembledFinalConsonantOffsets[(charCode - 0xAC00) % 28];
			if (!finalConsonantLetter) {
				return character + letter;
			}
			
			const increment = finalConsonantLetter[letter];
			if (!increment) {
				return character + letter;
			}
			
			return String.fromCharCode(charCode + increment);
		}
	}
}

function deleteSingleLetter(character) {
	const charCode = character.charCodeAt(0);
	
	if (isFirstConsonant(character)) {
		const firstConsonantOffset = charCode - "ㄱ".charCodeAt(0);
		
		const decrement = firstConsonantLetterDissembly[firstConsonantOffset];
		if (!decrement) {
			return "";
		}
		
		return String.fromCharCode(charCode + decrement);
	}
	
	if (isVowel(character)) {
		const vowelOffset = charCode - "ㅏ".charCodeAt(0);
		const dissembleTarget = vowelDissemblyOffsets[vowelOffset];
		
		if (!dissembleTarget) {
			return "";
		}
		return String.fromCharCode(charCode + dissembleTarget);
	}
	
	const charOffset = charCode - 0xAC00;
	const firstConsonantOffset = (((charOffset - charOffset % 28) / 28) - (charOffset / 28 % 21)) / 21;
	const middleVowelOffset = charOffset / 28 % 21;
	
	if (isNoFinalConsonant(character)) {
		
		const dissembleTarget = vowelDissemblyOffsets[middleVowelOffset];
		if (!dissembleTarget) {
			return firstConsonants[firstConsonantOffset]; // 초성만 남김
		}
		
		return String.fromCharCode(0xAC00 + firstConsonantOffset * 28 * 21 + (middleVowelOffset + dissembleTarget) * 28);
	}
	
	const finalConsonantOffset = charOffset % 28;
	
	const finalConsonantDissemblyOffset = finalConsonantLetterDissemblyOffsets[finalConsonantOffset];
	if (finalConsonantDissemblyOffset) {
		return String.fromCharCode(charCode + finalConsonantDissemblyOffset);
	}
	return String.fromCharCode(0xAC00 + firstConsonantOffset * 28 * 21 + middleVowelOffset * 28);
}

let isUserTyping = false;

$j(document).ready(function() {
	const currentInputHolder = {
			current: $j("#textInput")
	};
	
	<c:forEach var="line" items="${keyboardSet}">
		<c:forEach var="k" items="${line}">
			<c:if test="${hangulSet.contains(keyboardValueTable.get(k))}">
				$j("#${k}").on("click", function() {
					const currentInput = currentInputHolder.current;
					const character = $j(this).text();
					if (isUserTyping) {
						console.log("user is typing");
						const selectionStart = currentInput[0].selectionStart;
						const selectionEnd = currentInput[0].selectionEnd;
						
						console.log("selectionStart=" + selectionStart);
						console.log("selectionEnd=" + selectionEnd);
						
						const currentVal = getValue();
						
						console.log(currentVal.substring(selectionStart - 1));
						console.log(character);
						
						console.log(assemble(currentVal.substring(selectionStart - 1), character));
						
						const assembled = assemble(currentVal.substring(selectionStart - 1, selectionStart), character);
						
						setValue(currentVal.substring(0, selectionStart - 1) + assembled + currentVal.substring(selectionEnd));
						
						currentInput[0].setSelectionRange(selectionStart + assembled.length - 1,
								selectionStart + assembled.length - 1);
						currentInput.trigger("focus");
					} else {
						console.log("user is not typing");
						const selectionStart = currentInput[0].selectionStart;
						const selectionEnd = currentInput[0].selectionEnd;
						
						console.log("selectionStart=" + selectionStart);
						console.log("selectionEnd=" + selectionEnd);
						console.log("character=" + character)
						
						const currentVal = getValue();
						
						console.log("before=" + currentVal);
						
						const newValue = currentVal.substring(0, selectionStart) + character + currentVal.substring(selectionEnd);
						
						setValue(newValue);
						currentInput[0].setSelectionRange(selectionStart + 1, selectionStart + 1);
						currentInput.trigger("focus");
						
						console.log("after=" + newValue);
						
						isUserTyping = true;
					}
				});
			</c:if>
			<c:if test="${!specialFunctionSet.contains(k) && !hangulSet.contains(keyboardValueTable.get(k))}">
				$j("#${k}").on("click", function() {
					insertSymbol($j(this).text());
				});
			</c:if>
		</c:forEach>
	</c:forEach>
	
	const upperCaseStateHolder = {
			isUpperCaseOn: false
	};
	
	$j("#shift").on("click", function() {
		if (upperCaseStateHolder.isUpperCaseOn) {
			<c:forEach var="entry" items="${upperCaseMap}">
				$j("#${entry.key}").text("${keyboardValueTable.get(entry.key)}");
			</c:forEach>
			upperCaseStateHolder.isUpperCaseOn = false;
		} else {
			<c:forEach var="entry" items="${upperCaseMap}">
				$j("#${entry.key}").text("${entry.value}");
			</c:forEach>
			upperCaseStateHolder.isUpperCaseOn = true;
		}
	});
	
	$j("#backspace").on("click", function() {
		const currentInput = currentInputHolder.current;
		
		const fullText = getValue();
		
		console.log("fullText=" + fullText);
		
		const selectionStart = currentInput[0].selectionStart;
		const selectionEnd = currentInput[0].selectionEnd;
		
		if (fullText.length === 0 || (selectionStart === 0 && selectionEnd === 0)) {
			return;
		}
		
		if (isUserTyping) {
			const lastCharacter = fullText.substring(selectionStart - 1, selectionStart);
			const deleted = deleteSingleLetter(lastCharacter);
			setValue(fullText.substring(0, selectionStart - 1) + deleted + fullText.substring(selectionStart));
			if (deleted.length === 0) {
				isUserTyping = false;
				currentInput[0].setSelectionRange(selectionStart - 1, selectionStart - 1);
				currentInput.trigger("focus");
			} else {
				currentInput[0].setSelectionRange(selectionStart, selectionEnd);
				currentInput.trigger("focus");
			}
		} else {
			if (selectionStart === selectionEnd) {
				setValue(fullText.substring(0, selectionStart - 1) + fullText.substring(selectionEnd));
				
				currentInput[0].setSelectionRange(selectionStart - 1, selectionStart - 1);
				currentInput.trigger("focus");
			} else {
				const diff = selectionEnd - selectionStart;
				
				setValue(fullText.substring(0, selectionStart) + fullText.substring(selectionEnd));
				
				console.log("diff=" + diff);
				console.log("new=" + fullText.substring(0, selectionStart) + fullText.substring(selectionEnd));
				
				currentInput[0].setSelectionRange(selectionEnd - diff, selectionEnd - diff);
				currentInput.trigger("focus");
			}
		}
	});
	
	$j("#spacebar").on("click", function() {
		insertSymbol(" ");
	});
	
	$j("#enter").on("click", function() {
		insertSymbol("\n");
	});
	
	function insertSymbol(symbol) {
		isUserTyping = false;
		const currentInput = currentInputHolder.current;
		
		const fullText = getValue();
		const selectionStart = currentInput[0].selectionStart;
		const selectionEnd = currentInput[0].selectionEnd;
		
		setValue(fullText.substring(0, selectionStart) + symbol + fullText.substring(selectionEnd));
		
		currentInput[0].setSelectionRange(selectionStart + symbol.length, selectionStart + symbol.length);
		currentInput.trigger("focus");
	}
	
	$j(".toInput").on("mousedown", function() {
		isUserTyping = false;
		currentInputHolder.current = $j(this);
	});
	
	$j("#addTextarea").on("click", function() {
		const newTextarea = $j("<textarea rows=\"4\" cols=\"30\" class=\"toInput\"></textarea>");
		newTextarea.on("mousedown", function() {
			isUserTyping = false;
			currentInputHolder.current = $j(this);
		});
		
		$j("#textareaContainer").append(newTextarea);
	});

	function getValue(value) {
		return currentInputHolder.current.text();
	}

	function setValue(value) {
		currentInputHolder.current.text(value);
	}
});
</script>
</head>
<body>
	<table align="center">
		<c:forEach var="line" items="${keyboardSet}">
			<tr>
				<c:forEach var="k" items="${line}">
					<td>
						<button type="button" id="${k}">${keyboardValueTable.get(k)}</button>
					</td>
				</c:forEach>
			</tr>
		</c:forEach>
		<tr align="center">
			<td colspan="100%">
				<button type="button" id="spacebar">Space Bar</button>
			</td>
		</tr>
	</table>
	
	<button id="addTextarea">텍스트area 추가</button>
	<div id="textareaContainer" style="display: flex; flex-direction: column;">
		<textarea class="toInput" rows="4" cols="30"></textarea>
		<textarea class="toInput" rows="4" cols="30"></textarea>
	</div>
</body>
</html>