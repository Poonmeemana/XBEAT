import Foundation

struct PlanSegment: Identifiable {
    let id = UUID()
    var cadence:Double = 0.0
    var time: Int = 0
    var min:Int = 0
    var sec:Int = 0
    var ratio:String = ""
}
