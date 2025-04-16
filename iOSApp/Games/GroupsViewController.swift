import UIKit

class GroupsViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    var groups: [Group] = []  // Replace `Group` with your model type
    var selectedGroup: Group?

    override func viewDidLoad() {
        super.viewDidLoad()
        let title_label = UILabel(frame: CGRect(x: self.view.frame.size.width/8, y: self.view.frame.size.height / 12, width: 300, height: 40))
        title_label.text = String()
        title_label.textAlignment = .center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayGroupButtons()
        print("Groups received: \(groups.count)")
    }

    func displayGroupButtons() {
        for (index, group) in groups.enumerated() {
            let button = UIButton(frame: CGRect(x: Int(self.view.frame.size.width)/8, y: 120 + index * 50, width: 300, height: 40))
            button.setTitle(group.group_name, for: .normal)
            button.backgroundColor = .systemBlue
            button.tag = index
            button.addTarget(self, action: #selector(groupButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
    }

    @objc func groupButtonTapped(_ sender: UIButton) {
        selectedGroup = groups[sender.tag]
        performSegue(withIdentifier: "ShowMembersSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMembersSegue" {
            let destinationVC = segue.destination as! MembersViewController
            destinationVC.members = selectedGroup?.members ?? []  // Pass members to next VC
        }
    }
}
