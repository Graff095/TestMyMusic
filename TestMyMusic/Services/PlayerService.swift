import Foundation
import AVFAudio

class PlayerService: NSObject {

	var songsList = [Soung]()
    weak var delegate: PlayerServiceDelegate?
	static var shared = PlayerService()

	private var player: AVAudioPlayer?
	private var lastPlayedTrack: Soung?
	private var currentSong: Soung?

	var duration: TimeInterval? {
		player?.duration
	}

	var currentTime: TimeInterval? {
		player?.currentTime
	}

	var isPlaying: Bool {
		player?.isPlaying ?? false
	}

	func startPlay(song: Soung?) {
		guard let song = song else { return }
		self.currentSong = song
		guard lastPlayedTrack != song else {
			player?.play()
			return
		}
        
		lastPlayedTrack = song

		let urlString = Bundle.main.path(forResource: song.name, ofType: "mp3") ?? ""
		let url = URL(fileURLWithPath: urlString)

		try? AVAudioSession.sharedInstance().setMode(.default)
		try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
		player = try? AVAudioPlayer(contentsOf: url)
		player?.delegate = self
		guard let player = player else { return }
		player.play()
	}

	func start() {
		player?.play()
	}

	func stop() {
		player?.pause()
	}

	func previosSong() -> Soung? {
		guard let currentSong,
			  let currentIndex = songsList.firstIndex(of: currentSong) else { return nil}

		if currentIndex - 1 >= 0 {
			let previosSong = songsList[currentIndex - 1]
			startPlay(song: previosSong)
			return previosSong
		} else {
			guard songsList.count > 1 else { return currentSong }
			let previosSong = songsList.last
			startPlay(song: previosSong)
			return previosSong
		}
	}

    @discardableResult
    
	func nextSong() -> Soung? {
		guard let currentSong,
			  let currentIndex = songsList.firstIndex(of: currentSong) else { return nil}

		if currentIndex + 1 < songsList.count {
			let nextSong = songsList[currentIndex + 1]
			startPlay(song: nextSong)
			return nextSong
		} else {
			guard songsList.count > 1 else { return currentSong }
			let nextSoug = songsList.first
			startPlay(song: nextSoug)
			return nextSoug
		}
	}
}

extension PlayerService: AVAudioPlayerDelegate {
    
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        nextSong()
        let newTrack = currentSong
        guard let newTrack = newTrack else {return}
        delegate?.trackDidChange(newTrack: newTrack)
        
	}
    
}
protocol PlayerServiceDelegate: AnyObject {
    func trackDidChange(newTrack: Soung)
}
