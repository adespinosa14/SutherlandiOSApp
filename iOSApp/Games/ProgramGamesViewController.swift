import UIKit

class ProgramGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var games: [Games] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "gameCell")
        cell.textLabel?.text = games[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        fetchGameDetails(gameId: selectedGame.id)
    }

    // ✅ This matches your JSON structure now
    func fetchGameDetails(gameId: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/games/\(gameId)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(GameResponse.self, from: data)

                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let gameVC = storyboard.instantiateViewController(withIdentifier: "GroupsViewController") as! GroupsViewController
                    gameVC.groups = decoded.groups  // ✅ this now works
                    self.navigationController?.pushViewController(gameVC, animated: true)
                }
            } catch {
                print("Error decoding game detail: \(error)")
            }
        }
        task.resume()
    }
}
