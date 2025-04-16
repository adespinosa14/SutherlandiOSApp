//
//  EventsMain.swift
//  iOSApp
//
//  Created by Andrew Espinosa on 11/24/24.
//

import UIKit
import WebKit

class EventsMain: UIViewController, EventModelDelegate, UITableViewDelegate, UITableViewDataSource, WKUIDelegate
{
    
    @IBOutlet var eventsTable: UITableView!
    
    @IBOutlet weak var webPageView: WKWebView!
    
    var eventModel = EventsContext()
    var new_events = [Event]()
    
    override func viewDidLoad()
    {
        webPageView.uiDelegate = self
        let myUrl = URL(string: "https://www.scottsutherlandmusic.com/")
        let myRequest = URLRequest(url: myUrl!)
        webPageView.load(myRequest)
        
        let nib = UINib(nibName: "EventCellTableViewCell", bundle: nil)
        eventsTable.register(nib, forCellReuseIdentifier: "EventCell")
        eventsTable.delegate = self
        eventsTable.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.eventsTable.refreshControl = refreshControl
        
        eventModel.delegate = self
        eventModel.getItems()
        fetchGames()
    }
    
    @objc func refresh(_ sender: Any)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0)
        {
            self.itemsDownloaded(new_events: self.new_events)
            self.eventsTable.reloadData()
            self.eventsTable.refreshControl?.endRefreshing()
        }
    }
    
    func itemsDownloaded(new_events: [Event]) {
        self.new_events = new_events
        DispatchQueue.main.async
        {
            self.eventsTable.reloadData()
        }
    }
    
//MARK: Table View
    // Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(new_events[indexPath.row])
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return new_events.count
    }
    
    // Create Unique Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCellTableViewCell
        cell.eventIdLabel.text! += new_events[indexPath.row].eventId
        cell.eventNameLabel.text = new_events[indexPath.row].eventName
        cell.eventLocationLabel.text = new_events[indexPath.row].eventLocation
        cell.eventDescriptionLabel.text = new_events[indexPath.row].eventDescription
        cell.eventDateLabel.text = new_events[indexPath.row].eventDate
        
        return cell
    }

//MARK: Fetch Games
    func fetchGames() {
            guard let url = URL(string: "http://127.0.0.1:5000/api/programs") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let programs = try JSONDecoder().decode([Programs].self, from: data)
                    print("Fetched games: \(programs)")
                    
                    // Example: Access the first game's name
                    if let activeProgram = programs.first(where: { $0.state == true }) {
                                DispatchQueue.main.async {
                                    self.showAlert(for: activeProgram)
                                }
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
    func showAlert(for program: Programs) {
        let alert = UIAlertController(title: "Active Program Detected",
                                      message: "The Program \(program.name) is active. Do you want to join?",
                                      preferredStyle: .alert)
        
        let viewAction = UIAlertAction(title: "Join Program", style: .default) { _ in
            self.navigateToGroupsPage(for: program)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(viewAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToGroupsPage(for program: Programs) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let programGamesVC = storyboard.instantiateViewController(withIdentifier: "ProgramGamesViewController") as! ProgramGamesViewController
        programGamesVC.games = program.games
        self.navigationController?.pushViewController(programGamesVC, animated: true)

    }
}

