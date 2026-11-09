import SwiftUI

struct ContentView: View {

    @State private var planSegment: [PlanSegment] = [PlanSegment()]
    @State private var showInputSheet = false
    let options = ["3:3", "3:2", "2:2", "2:1", "None"]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                Text("XBEAT")
                    .font(.largeTitle).bold()
            }
            .padding(.top, 60)

            // Card Section
            ZStack {
                ScrollView {
                    VStack {
                        ForEach(Array(planSegment.enumerated()), id: \.1.id) { index, segment in
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Segment \(index + 1)")
                                        .font(.title3).bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                    Button(action: {
                                        if let index = planSegment.firstIndex(where: { $0.id == segment.id }) {
                                            planSegment.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.system(size: 22))
                                    }
                                }

                                HStack {
                                    Label("Enter time (min)", systemImage: "clock")
                                    Spacer()
                                    TextField("min", text: Binding(
                                        get: { segment.min == 0 ? "" : String(segment.min) },
                                        set: { val in
                                            if let value = Int(val),
                                               let index = planSegment.firstIndex(where: { $0.id == segment.id }) {
                                                planSegment[index].min = value
                                                updateTime(for: index)
                                            }
                                        }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)

                                    TextField("sec", text: Binding(
                                        get: { segment.sec == 0 ? "" : String(segment.sec) },
                                        set: { val in
                                            if let value = Int(val),
                                               let index = planSegment.firstIndex(where: { $0.id == segment.id }) {
                                                planSegment[index].sec = value
                                                updateTime(for: index)
                                            }
                                        }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)
                                }

                                HStack {
                                    Label("Cadence", systemImage: "target")
                                    Spacer()
                                    TextField("steps/min", text: Binding(
                                        get: { segment.cadence == 0 ? "" : String(format: "%.0f", segment.cadence) },
                                        set: { val in
                                            if let value = Double(val),
                                               let index = planSegment.firstIndex(where: { $0.id == segment.id }) {
                                                planSegment[index].cadence = value
                                            }
                                        }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 100)
                                }

                                HStack {
                                    Label("Breathing Ratio", systemImage: "lungs")
                                    Spacer()
                                    Picker(selection: Binding(
                                        get: { segment.ratio },
                                        set: { val in
                                            if let index = planSegment.firstIndex(where: { $0.id == segment.id }) {
                                                planSegment[index].ratio = val
                                            }
                                        }
                                    ), label: Text(segment.ratio.isEmpty ? "Select" : segment.ratio)) {
                                        ForEach(options, id: \.self) { option in
                                            Text(option)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 8)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                        }
                    }
                }
                FloatingAddButton {
                    planSegment.append(PlanSegment())
                }
            }

            // Buttons
            VStack(spacing: 12) {
                NavigationLink(destination: RunPlanView(segment: planSegment)) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("USE THIS PLAN")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Button(action: {
                    showInputSheet = true
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("AUTO-PLAN FOR ME")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 1))
                    .foregroundColor(.blue)
                }
                .sheet(isPresented: $showInputSheet) {
                    PlanInputSheet(isPresented: $showInputSheet, segments: $planSegment)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .ignoresSafeArea()
    }

    private func updateTime(for index: Int) {
        let min = planSegment[index].min
        let sec = planSegment[index].sec
        planSegment[index].time = (min * 60) + sec
    }
}
