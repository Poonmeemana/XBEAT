import Foundation
import AVFoundation

class MetronomePlayer: ObservableObject {
    enum SoundType {
        case high, mid, low
    }

    private var audioPlayers: [SoundType: AVAudioPlayer] = [:]
    private var timer: Timer?
    private var pattern: [SoundType] = []
    private var patternIndex = 0

    @Published var currentSound: SoundType?

    init() {
        loadSounds()
    }

    private func loadSounds() {
        audioPlayers[.high] = loadSound(named: "high")
        audioPlayers[.mid] = loadSound(named: "mid")
        audioPlayers[.low] = loadSound(named: "low")
    }

    private func loadSound(named name: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            return nil
        }
        return try? AVAudioPlayer(contentsOf: url)
    }

    func start(cadence: Double, ratio: String) {
        stop()
        pattern = createPattern(for: ratio)
        patternIndex = 0

        let interval = 60.0 / cadence
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            let sound = self.pattern[self.patternIndex % self.pattern.count]
            self.currentSound = sound
            self.audioPlayers[sound]?.play()
            self.patternIndex += 1
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func createPattern(for ratio: String) -> [SoundType] {
        switch ratio {
        case "3:3": return [.high, .low, .low, .mid, .low, .low]
        case "3:2": return [.high, .low, .low, .mid, .low]
        case "2:2": return [.high, .low, .mid, .low]
        case "2:1": return [.high, .low, .mid]
        case "none": return [.low, .low, .low, .low] // 4 steps for cadence, no breathing
        default: return [.low]
        }
    }
}
