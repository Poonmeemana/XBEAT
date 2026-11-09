import SwiftUI

struct RunPlanView: View {
    var segment: [PlanSegment]
    @State private var currentIndex = 0
    @State private var timeRemaining = 0
    @State private var timer: Timer?
    @StateObject private var metronome = MetronomePlayer()
    @State private var isLeftStep = true
    @State var status = false
    @State var first = false
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("RUN PLAN VIEW").font(.largeTitle).bold()
                    .padding()

                VStack {
                    Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))
                        .font(.system(size: 70))
                    if currentIndex < segment.count {
                        let now = segment[currentIndex]
                        let a = Int(now.cadence)
                        Text("(\(a) steps/min , \(now.ratio))")
                            .foregroundColor(.black)
                            .opacity(0.8)
                    } else {
                        Text("FINISHED!!!")
                            .foregroundColor(.green)
                            .font(.title)
                    }
                }

                .padding(.vertical , 12)
                .padding(.horizontal)

                Image(isLeftStep ? "stepLeft" : "stepRight")
                    .resizable()
                    .scaledToFit()
                    .frame(width : 270 , height : 270)

                Text(currentSoundLabel())
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)

                Spacer()
                if !status , !first {
                    Button(action: { startTimer() }, label: {
                        Image(systemName: "play.fill")
                            .font(.title)
                    })
                    .frame(width: 120, height: 58, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 8)
                    .padding(.bottom , 60)

                } else {
                    HStack(spacing : 50) {

                        Button(action: { resetTimer() }, label: {
                            Image(systemName: "stop.fill")
                        })
//                        .padding()
                        .frame(width: 58, height: 58, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                        .padding(.bottom , 60)

                        if !status  {
                            Button(action: { startTimer() }, label: {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.blue)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            })
//                            .padding(.bottom , 60)
                            .frame(width: 58, height: 58, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                            .cornerRadius(100)
                            .shadow(radius: 8)
                            .padding(.bottom , 60)

                        } else {
                            Button(action: { stopTimer() }, label: {
                                Image(systemName: "pause.fill")
                                    .foregroundColor(.blue)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            })
//                            .padding(.bottom , 60)
                            .frame(width: 58, height: 58, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                            .cornerRadius(100)
                            .shadow(radius: 8)
                            .padding(.bottom , 60)

                        }
                    }
                    .font(.title2)

                }

            }
            .padding()
            .onReceive(metronome.$currentSound) { _ in
                isLeftStep.toggle()
            }
            .onAppear {
                if segment.indices.contains(currentIndex) {
                    timeRemaining = segment[currentIndex].time
                }
            }
            .onDisappear {
                stopTimer()
        }
        }
    }

    func currentSoundLabel() -> String {
        guard currentIndex < segment.count else { return "" }
        switch metronome.currentSound {
        case .high: return "INHALE + STEP"
        case .mid: return "EXHALE + STEP"
        case .low: return "STEP"
        default: return ""
        }
    }

    func startTimer() {

        stopTimer()
        status = true
        first = true
        guard currentIndex < segment.count else { return }

        let seg = segment[currentIndex]
        metronome.start(cadence: seg.cadence, ratio: seg.ratio)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                nextSegment()
            }
        }
    }

    func stopTimer() {
        status = false
        timer?.invalidate()
        timer = nil
        metronome.stop()
    }

    func resetTimer() {
        status = false
        first = false
        stopTimer()
        currentIndex = 0
        if segment.indices.contains(currentIndex) {
            timeRemaining = segment[currentIndex].time
        }
    }

    func nextSegment() {
        currentIndex += 1
        if currentIndex < segment.count {
            timeRemaining = segment[currentIndex].time
            startTimer()
        } else {
            stopTimer()
        }
    }
}
