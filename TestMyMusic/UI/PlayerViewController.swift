//
//  PlayerViewController.swift
//  TestMyMusic
//
//  Created by Visarg on 09.09.2023.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController,PlayerServiceDelegate {
    
    public var song: Soung?

    @IBOutlet var holder: UIView!
    
	var player: PlayerService = PlayerService.shared
    var timer: Timer!
    
    //MARK: Элементы пользовательского интерфейса
    
    let backViewButton: UIButton = {
        let button = UIButton ()
        button.frame = CGRect(x: 10, y: 10, width: 75, height: 35)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.setTitle("Close", for: .normal)

        return  button
    }()

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let nameArtist: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    private let trekTime: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let endTrekTime: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    private let progressView: UIProgressView  = {
        let progress = UIProgressView()
        return progress
    }()
    
    //MARK: Player controls
    let playPauseButton = UIButton()
    let nextButton = UIButton()
    let backPauseButton = UIButton()
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
        player.delegate = self
	}
   
    private func configure() {
        
        // set up player
		guard let song = song else {
			assertionFailure("Проставьте трек в контроллер")
			return
		}

		player.startPlay(song: song)
        
        // alnum cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 80,
                                      width: holder.frame.size.width - 20,
                                      height: holder.frame.size.width - 20)
        

        
       // Labels
        songNameLabel.frame = CGRect(x: 10,
                                     y:  albumImageView.frame.size.height + 60,
                                     width: holder.frame.size.width - 20,
                                     height: 70)
        nameArtist.frame = CGRect(x: 10,
                                     y:  albumImageView.frame.size.height + 80,
                                     width: holder.frame.size.width - 20,
                                     height: 70)
        
        trekTime.frame = CGRect(x: 10,
                                      y: 350,
                                      width: holder.frame.size.width - 20,
                                      height: holder.frame.size.width - 20)
        endTrekTime.frame = CGRect(x: 340,
                                      y: 350,
                                      width: holder.frame.size.width - 20,
                                      height: holder.frame.size.width - 20)
        
        //progressView
        progressView.frame = CGRect(x: 10,
                                y: 560,
                                width: holder.frame.size.width - 20,
                                height: holder.frame.size.width - 20)

        // Add actions
        backViewButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backPauseButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // Frame
        
        let yPosition = nameArtist.frame.origin.y + 80 + 50
        let size: CGFloat = 60
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        backPauseButton.frame = CGRect(x: 20,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        // Styling
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backPauseButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backPauseButton)
        
        holder.addSubview(backViewButton)
		holder.addSubview(albumImageView)
        holder.addSubview(progressView)
        holder.addSubview(songNameLabel)
        holder.addSubview(nameArtist)
        holder.addSubview(trekTime)
        holder.addSubview(endTrekTime)

		updateData()
    }

	func updateData() {
		guard let song else { return }
		albumImageView.image = UIImage(named: song.nameImage)
		songNameLabel.text = song.name
		nameArtist.text = song.nameArtist
		setupProgressView()
	}
   
    func trackDidChange(newTrack: Soung) {
        self.song = newTrack
        updateData()
    }
    
    func setupProgressView() {
           progressView.progress = 0.0
		let duration = player.duration
        guard let duration = duration else {return}
        endTrekTime.text = formatTime(duration)
           timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
       }

    func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapBackButton () {
		self.song = player.previosSong()
		updateData()
    }
    
    @objc func didTapNextButton () {
		self.song = player.nextSong()
		updateData()
    }
    
    @objc func didTapPlayPauseButton () {
        
        if player.isPlaying {
            // pause
            player.stop()
            // swow play  button
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
        } else {
            // play
            player.start()
            // swow play  button
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func updateProgressView() {
        let currentTime = player.currentTime
        let duration = player.duration
		guard let durations = duration,
			  let currentTime = currentTime else {return}

        let progress = Float(currentTime / durations)
        progressView.progress = progress
        trekTime.text = formatTime(currentTime)
        }
}
