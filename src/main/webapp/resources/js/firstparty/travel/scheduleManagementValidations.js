function validate(travelInfoPerDay, beforenoon, afternoon) {
	console.log(travelInfoPerDay);
	for (let day of Object.keys(travelInfoPerDay)) {
		const problem = validatePerDay(travelInfoPerDay[day], beforenoon, afternoon);
		if (Object.keys(problem).length !== 0) {
			problem.day = parseInt(day);
			return problem;
		}
	}
	
	return {};
}

function validatePerDay(travelInfos, beforenoon, afternoon) {
	travelInfos.sort(getCompareFunctionForTravelInfoInTimeOrder(beforenoon, afternoon));
	console.log("Heere: ");
	console.log(travelInfos);
	/*
	if (travelInfos.length < 1) {
		return {};
	} else if (travelInfos.length === 1) {
		if (travelInfos[0].travelTime.length === 0
				&& travelInfos[0].travelLoc.length === 0
				&& travelInfos[0].travelDetail.length === 0) {
			return {};
		}
	}*/
	/*
	const scheduleTimeResult = validateScheduleRange(travelInfos, beforenoon, afternoon);
	if (Object.keys(scheduleTimeResult).length !== 0) {
		return scheduleTimeResult;
	}*/
	
	const result = validateScheduleTimeOfDay(travelInfos, beforenoon, afternoon);
	console.log(result);
	if (Object.keys(result).length !== 0) {
		return result;
	}
	
	for (let i = 0; i < travelInfos.length; i++) {
		const elem = travelInfos[i];
		const problem = validatePerIdx(elem, beforenoon, afternoon);
		if (Object.keys(problem).length !== 0) {
			problem.idx = i;
			return problem;
		}
	}
	return {};
}

function validatePerIdx(travelInfo, beforenoon, afternoon) {
	/*
	if (travelInfo.length <= 1) {
		if (travelInfo.travelTime.length === 0
				&& travelInfo.travelLoc.length === 0
				&& travelInfo.travelDetail.length === 0) {
			return {};
		}
	}*/
	
	if (travelInfo.travelLoc.length === 0) {
		return { problem: "travelLoc", causeNum: 1 };
	}
	
	if (travelInfo.travelDetail.length === 0) {
		return { problem: "travelDetail", causeNum: 1 };
	}
	return {};
}

function validateScheduleRange(travelInfos, beforenoon, afternoon) {
	for (let i = 0; i < travelInfos.length; i++) {
		if (travelInfos[i].travelTime.length === 0) {
			return { problem: "travelTime", causeNum: 1, idx: i };
		}
		
		if (!new RegExp(`^(${beforenoon}|${afternoon}) \\d{2}:\\d{2}$`).test(travelInfos[i].travelTime)) {
			return { problem: "travelTime", causeNum: 2, idx: i };
		}
		
		const result = validateAvailableTime(travelInfos[i].travelTime, beforenoon, afternoon);
		if (Object.keys(result).length > 0) {
			result.idx = i;
			return result;
		}
	}
	return {};
}

function validateAvailableTime(time, beforenoon, afternoon) {
	const [hour, minute] = to24Time(time, beforenoon, afternoon).split(":").map((e) => parseInt(e));
	console.log("hour=" + hour);
	console.log("minute=" + minute);
	if (hour > 4 && hour < 7
			|| hour === 4 && minute > 0) {
		return {
			problem: "travelTime",
			causeNum: 4
		}
	}
	return {};
}

function to24Time(travelTime, beforenoon, afternoon) {
	let [hour, minute] = travelTime.substring(beforenoon.length).trim().split(":").map((e) => parseInt(e));
	hour += travelTime.startsWith(afternoon) ? 12 : 0;
	if (travelTime.startsWith(beforenoon)) {
		hour %= 12;
	} else {
		hour = hour % 12 + 12;
	}
	return (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
}

function validateScheduleTimeOfDay(travelInfo, beforenoon, afternoon) {
	
	
	console.log(travelInfo);
	const scheduleTimes = travelInfo.map((e) => {
		let [hour, minute] = to24Time(e.travelTime, beforenoon, afternoon).split(":").map((e) => parseInt(e));
		let from = new Date(2000, 0, 1 + (hour >= 0 && hour <= 4 ? 1 : 0), hour, minute);
		let to = new Date(from);
		to.setMinutes(to.getMinutes() + e.transTime);
		return {
			from: from,
			to: to
		};
	});
	
	console.log(scheduleTimes);
	const firstResult = validateSingleTimeFormat(travelInfo[0].travelTime, beforenoon, afternoon);
	if (Object.keys(firstResult).length > 0) {
		firstResult.idx = 0;
		return firstResult;
	}
	
	for (let i = 1; i < scheduleTimes.length; i++) {
		const formatValidation = validateSingleTimeFormat(travelInfo[i].travelTime, beforenoon, afternoon);
		if (Object.keys(formatValidation).length > 0) {
			formatValidation.idx = i;
			return formatValidation;
		}
		
		const cursor = scheduleTimes[i];
		const before = scheduleTimes[i - 1];
		if (cursor.from < before.to) {
			return {
				problem: "travelTime",
				causeNum: 3,
				idx: i
			}
		}
		console.log("cursor.from=" + cursor.from);
		console.log("before.from=" + before.from);
		if (cursor.from - before.from === 0) {
			return {
				problem: "travelTime",
				causeNum: 6,
				idx: i
			}
		}
	}
	
	const last = scheduleTimes[scheduleTimes.length - 1];
	if (last.to > new Date(2000, 0, 2, 4, 0)) {
		return {
			problem: "travelTime",
			causeNum: 5,
			idx: scheduleTimes.length - 1
		}
	}
	
	return {};
}

function validateSingleTimeFormat(travelTime, beforenoon, afternoon) {
	if (travelTime.length === 0) {
		return { problem: "travelTime", causeNum: 1 };
	}
	
	if (!new RegExp(`^(${beforenoon}|${afternoon}) \\d{2}:\\d{2}$`).test(travelTime)) {
		return { problem: "travelTime", causeNum: 2 };
	}
	
	const result = validateAvailableTime(travelTime, beforenoon, afternoon);
	if (Object.keys(result).length > 0) {
		return result;
	}
	return {};
}

function getTransportFee(travelInfo, beforenoon, afternoon) {
	const transTime = travelInfo.transTime;
	
	console.log(travelInfo);
	if (transTime === 0) {
		console.log("here");
		return 0;
	}
	const travelTime = travelInfo.travelTime;
	if (!travelTime || travelTime.length === 0) {
		return 0;
	}
	
	let [hour, minute] = to24Time(travelTime, beforenoon, afternoon).split(":").map((e) => parseInt(e));
	console.log("hour=" + hour);
	console.log("minute=" + minute);
	
	let baseFee = 0;
	switch (travelInfo.travelTrans) {
		case "T":
			if (hour >= 0 && hour <= 4) {
				hour += 24;
			}
			
			const travelTimeInMinutes = hour * 60 + minute;
			const transTimePeriod = Math.floor((transTime - 1) / 10);
			
			let additionalFee = 0;
			let timeCursur = travelTimeInMinutes + 1;
			for (let i = 0; i < transTimePeriod; i++) {
				timeCursur += 10;
				if (timeCursur > 28 * 60) {
					additionalFee += 0;
				} else if (timeCursur > 24 * 60) {
					additionalFee += 5000 * 1.4;
				} else if (timeCursur > 22 * 60) {
					additionalFee += 5000 * 1.2;
				} else {
					additionalFee += 5000;
				}
			}
			
			let baseFeeAdd;
			const baseFeeTime = travelTimeInMinutes;
			if (baseFeeTime > 24 * 60) {
				baseFeeAdd = 1.4;
			} else if (baseFeeTime > 22 * 60) {
				baseFeeAdd = 1.2;
			} else {
				baseFeeAdd = 1;
			}
			return 3800 * baseFeeAdd + additionalFee;
		case "B":
			baseFee = 1400;
		case "S":
			const transTimeStep = Math.floor(transTime / 20);
			if (baseFee === 0) {
				baseFee = 1450;
			}
			return baseFee + 200 * transTimeStep;
		case "C":
		case "R":
			return Math.ceil(transTime / 10) * 500;
		default:
			return 0;
	}
}

function calculateSurchargeTime(timeInMinutes, transTime) {
    let surcharge1Time = 0;
    let surcharge2Time = 0;
    if (timeInMinutes >= 0 && timeInMinutes <= 4 * 60) {
        const overTime = transTime + timeInMinutes - 4 * 60;
        surcharge1Time = transTime - (overTime > 0 ? overTime : 0);
    } else if (timeInMinutes >= 22 * 60 && timeInMinutes <= 24 * 60) {
        const overTime = timeInMinutes + transTime - 24 * 60;
        surcharge1Time = overTime > 0 ? calculateSurchargeTime(0, overTime)[0] : 0;
        surcharge2Time = transTime - (overTime > 0 ? overTime : 0);
    } else {
        const overTime1 = timeInMinutes + transTime - 22 * 60;
        const overTime2 = timeInMinutes + transTime - 24 * 60;
        surcharge1Time = overTime2 > 0 ? calculateSurchargeTime(0, overTime2)[0] : 0;
        surcharge2Time = (overTime1 > 0 ? calculateSurchargeTime(22 * 60, overTime1 - (overTime2 > 0 ? overTime2 : 0))[1] : 0);
    }

    return [surcharge1Time, surcharge2Time];
}

function getCompareFunctionForTravelInfoInTimeOrder(beforenoon, afternoon) {
	return (t1, t2) => {
		if (t1.travelTime.length === 0) {
			return 1;
		} else if (t2.travelTime.length === 0) {
			return -1;
		}
		
		const travelTime1In24 = to24Time(t1.travelTime, beforenoon, afternoon);
		const travelTime2In24 = to24Time(t2.travelTime, beforenoon, afternoon);
		const [hour1, minute1] = travelTime1In24.split(":").map((e) => parseInt(e));
		const [hour2, minute2] = travelTime2In24.split(":").map((e) => parseInt(e));
		
		if (hour2 >= 0 && hour2 <= 4 && hour1 > 4) {
			return -1;
		} else if (hour1 >= 0 && hour1 <= 4 && hour2 > 4) {
			return 1;
		} else {
			if (travelTime1In24 < travelTime2In24) {
				return -1;
			} else if (travelTime1In24 > travelTime2In24) {
				return 1;
			} else {
				return 0;
			}
		}
	}
}

function wasAnyInputOccurred(travelInfoOfDay) {
	for (let travelInfo of travelInfoOfDay) {
		if (
			travelInfo.transTime !== 0
					|| travelInfo.travelDetail.length !== 0
					|| travelInfo.travelLoc.length !== 0
					|| travelInfo.travelTime.length !== 0
					|| travelInfo.useExpend !== 0
		) {
			return true;
		}
	}
	return false;
}

function hasChanged(travelInfoOfDay, originalTravelInfoOfDay) {
	console.log(travelInfoOfDay);
	console.log("--------------------------");
	console.log(originalTravelInfoOfDay);
	const copied = JSON.parse(JSON.stringify(travelInfoOfDay)).filter((e) => e.transTime !== 0
					|| e.travelDetail.length !== 0
					|| e.travelLoc.length !== 0
					|| e.travelTime.length !== 0
					|| e.useExpend !== 0);
	
	for (let i = 0; i < copied.length; i++) {
		const t1 = copied[i];
		const t2 = originalTravelInfoOfDay[i];
		if (!t2) {
			return true;
		}
		if (
			t1.transTime !== t2.transTime
					|| t1.travelCity !== t2.travelCity
					|| t1.travelCounty !== t2.travelCounty
					|| t1.travelDetail !== t2.travelDetail
					|| t1.travelLoc !== t2.travelLoc
					|| t1.travelTime !== t2.travelTime
					|| t1.travelTrans !== t2.travelTrans
		) {
			return true;
		}
	}
	return false;
}