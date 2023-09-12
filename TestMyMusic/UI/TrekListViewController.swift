//
//  ViewController.swift
//  TestMyMusic
//
//  Created by Visarg on 08.09.2023.
//

import UIKit

class TrekListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
     
    var song:[Soung] = [Soung(name: "Звери - До скорой встречи", nameImage: "Zveri - Районы-кварталы", nameArtist: "Zveri", time: "3:20"),
                        Soung(name: "Звери - Районы-кварталы", nameImage: "Zveri - До скорой встречи", nameArtist: "Zveri", time: "6:24"),
                        Soung(name: "Be Mine Song by Ofenbach", nameImage: "Ofenbach", nameArtist: "Ofenbach", time: "2:41")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Musik"
		PlayerService.shared.songsList = song
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "customCell")
    }
    
}

extension TrekListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		song.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell
        
        let song = song[indexPath.row]
        cell?.commonInit(song.name, song.nameImage, song.time)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
		guard position < song.count,
			  let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
			return
		}
        
        vc.song = song[position]
        
        present(vc, animated: true)
    }
    
}

struct Soung: Equatable {
    let name: String
    let nameImage: String
    let nameArtist: String
    let time: String
}
