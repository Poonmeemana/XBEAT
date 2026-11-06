//import SwiftUI
//
//struct PlanInputSheet: View {
//    @Binding var isPresented: Bool
//    @Binding var segments: [PlanSegment]
//
//    @State private var strideLengthText = "" // ความยาวก้าว
//    @State private var distanceText = "" //ระยะทาง
//    @State private var timeText = "" //เวลา
//    @State private var selectedType: PlanType = .steady // แผนเเต่ละประเภท
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Input")) {
//                    TextField("Stride Length (m)", text: $strideLengthText)
//                    TextField("Distance (km)", text: $distanceText)
//                    TextField("Target Time (min)", text: $timeText)
//
//                    Picker("Plan Type", selection: $selectedType) {
//                        ForEach(PlanType.allCases) { type in
//                            Text(type.rawValue).tag(type)
//                        }
//                    }
//                }
//
//                Button("Generate Plan") {
//                    if let stride = Double(strideLengthText),
//                       let dist = Double(distanceText),
//                       let time = Double(timeText) {
//                        segments = generate(strideLength: stride, distance: dist, timeInMinutes: time, type: selectedType)
//                        isPresented = false
//                    }
//                }
//            }
//            .navigationTitle("Generate Plan")
//            .navigationBarItems(trailing: Button("Cancel") {
//                isPresented = false
//            })
//        }
//    }
//}
import SwiftUI

struct PlanInputSheet: View {
    @Binding var isPresented: Bool
    @Binding var segments: [PlanSegment]

    @State private var strideLengthText = ""
    @State private var minText = ""
    @State private var secText = ""
    @State private var distanceText = ""
    @State private var planTypeChoose: PlanType = .steady

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input")) {
                    TextField("Stride Length (m)", text: $strideLengthText)
                    TextField("Distance (km)", text: $distanceText)
                    HStack {
                        TextField("Time (min)", text: $minText)
                        TextField("Time (second)", text: $secText)
                    }
                    Picker("Plan Type", selection: $planTypeChoose) {
                        ForEach(PlanType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                Button("Generate Plan") {
                    if let stride = Double(strideLengthText) ,
                       let dist = Double(distanceText) ,
                       let min = Double(minText),
                       let sec = Double(secText)
                       {
                        let time = (min * 60) + sec
                        segments = generate(strideLength: stride, distance: dist, timeInSecond: time, type: planTypeChoose)
                        isPresented = false
                    }
                }
                .navigationTitle("Generate Plan")
                .navigationBarItems(trailing:  Button("Cancel") {
                    isPresented = false
                })
            }
        }
    }
}
