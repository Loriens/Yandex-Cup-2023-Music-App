//
//  AudioService.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import AVFoundation

final class AudioService {
    // MARK: - Props

    private var engine = AVAudioEngine()
    private var players: [AVAudioPlayerNode] = []

    // MARK: - Public functions

    func configureAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func play(samples: [Sample], completion: @escaping () -> Void) {
        if !players.isEmpty {
            stopPlaying()
        }

        let files: [AVAudioFile] = samples.compactMap {
            guard let fileUrl = Bundle.main.url(forResource: $0.fileName, withExtension: $0.fileExtension) else { return nil }
            return try? AVAudioFile(forReading: fileUrl)
        }

        guard !files.isEmpty else {
            completion()
            return
        }

        startEngine(files: files, completion: completion)
    }

    func stopPlaying() {
        players.forEach {
            $0.pause()
            engine.detach($0)
        }
        players = []
        engine.stop()
        engine.reset()
    }

    func record() {}

    func stopRecording() {}

    // MARK: - Private functions

    private func startEngine(files: [AVAudioFile], completion: @escaping () -> Void) {
        files.forEach { file in
            let player = AVAudioPlayerNode()
            let format = file.processingFormat
            engine.attach(player)
            engine.connect(
                player,
                to: engine.mainMixerNode,
                fromBus: 0,
                toBus: players.count + 1,
                format: format
            )
            players.append(player)
        }

        engine.prepare()

        try? engine.start()

        let group = DispatchGroup()

        files.enumerated().forEach { index, file in
            group.enter()
            players[index].scheduleFile(file, at: nil) {
                group.leave()
            }
            players[index].play()
        }

        group.notify(queue: .main) {
            completion()
        }
    }
}
