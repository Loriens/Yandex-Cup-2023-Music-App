//
//  AudioSampleService.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import AVFoundation

final class AudioSampleService {
    // MARK: - Props

    private var engine = AVAudioEngine()
    private var player = AVAudioPlayerNode()

    // MARK: - Public functions

    func play(sample: Sample, completion: @escaping () -> Void) {
        guard
            let fileUrl = Bundle.main.url(forResource: sample.fileName, withExtension: sample.fileExtension),
            let file = try? AVAudioFile(forReading: fileUrl)
        else { return }

        startEngine(file: file, completion: completion)
        player.play()
    }

    func stop(sample: Sample) {
        player.pause()
        engine.detach(player)
    }

    // MARK: - Private functions

    private func startEngine(file: AVAudioFile, completion: @escaping () -> Void) {
        engine.attach(player)
        engine.connect(
            player,
            to: engine.mainMixerNode,
            fromBus: .zero,
            toBus: AVAudioNodeBus(),
            format: file.processingFormat
        )

        engine.prepare()

        try? engine.start()
        player.scheduleFile(file, at: nil) {
            completion()
        }
    }
}
