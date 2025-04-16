import UIKit
import AVFoundation

class MembersViewController: UIViewController {
    var members: [Member] = []  // Replace `Member` with your model type
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        displayMemberButtons()
    }

    func displayMemberButtons() {
        for (index, member) in members.enumerated() {
            let button = UIButton(frame: CGRect(x: Int(self.view.frame.width) / 8, y: 100 + index * 120, width: 300, height: 80))
            button.setTitle(member.name, for: .normal)
            button.backgroundColor = .blue
            button.tag = index
            button.addTarget(self, action: #selector(memberButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
    }

    @objc func memberButtonTapped(_ sender: UIButton) {
        let member = members[sender.tag]
        playSound(for: member.sound_id)
    }

    func playSound(for soundId: String) {
        // Fetch the audio data from the API using soundId
        let urlString = "http://127.0.0.1:5000/api/sounds/\(soundId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch sound: \(error)")
                return
            }

            guard let data = data else { return }

            DispatchQueue.main.async {
                do {
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer?.play()
                } catch {
                    print("Failed to play sound: \(error)")
                }
            }
        }.resume()
    }
}
