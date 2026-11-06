import Foundation

func breathing(for pace: Double) -> String {
    if pace > 7 {
        return "3:3" // Easy
    } else if pace > 6 {
        return "3:2" // Moderate
    } else if pace > 5 {
        return "2:2" // Fast
    } else if pace > 4{
        return "2:1" // Very fast
    } else {
        return "2:1"
    }
}

import Foundation

func generate(strideLength: Double, distance: Double, timeInSecond: Double, type: PlanType) -> [PlanSegment] {
    let totalSteps = distance * 1000 / strideLength // (km->m) / m
    let totalMin = (timeInSecond / 60.0)
    let avgCadence = round(totalSteps / totalMin)
    let pace = round((totalMin / distance) * 100) / 100  // นาทีต่อกิโล
    print(pace)

    var segments: [PlanSegment] = []

    switch type {
    case .steady:
        let min = Int(timeInSecond) / 60
        let sec = Int(timeInSecond) % 60
        let time = Int(timeInSecond)

        segments.append(PlanSegment(
            cadence: avgCadence,
            time: time,
            min: min,
            sec: sec,
            ratio: breathing(for: pace)
        ))

    case .progressive:
        let warmUp = Int(round(timeInSecond * 0.3))
        let mid = Int(round(timeInSecond * 0.4))
        let end = Int(timeInSecond) - warmUp - mid

        segments.append(PlanSegment(cadence: avgCadence - 10, time: warmUp, min: warmUp/60, sec: warmUp%60, ratio: "3:3"))
        segments.append(PlanSegment(cadence: avgCadence, time: mid, min: mid/60, sec: mid%60, ratio: "3:2"))
        segments.append(PlanSegment(cadence: avgCadence + 5, time: end, min: end/60, sec: end%60, ratio: "2:2"))

    case .interval:
        let intervalTime = 180  // 3 นาทีต่อช่วง
        let totalAvailableTime = Int(timeInSecond)
        let repeatCount = totalAvailableTime / (intervalTime * 2)
        let usedTime = repeatCount * intervalTime * 2
        let remaining = totalAvailableTime - usedTime

        let slowPace = pace * 0.8
        let fastPace = pace * 1.2

        for _ in 0..<repeatCount {
            segments.append(PlanSegment(cadence: avgCadence + 10, time: intervalTime, min: intervalTime/60, sec: intervalTime%60, ratio: breathing(for: slowPace)))
            segments.append(PlanSegment(cadence: avgCadence - 10, time: intervalTime, min: intervalTime/60, sec: intervalTime%60, ratio: breathing(for: fastPace)))
        }

        if remaining > 0 {
            segments.append(PlanSegment(cadence: avgCadence, time: remaining, min: remaining/60, sec: remaining%60, ratio: breathing(for: slowPace)))
        }
    }

    return segments
}
