import UIKit

@objc(BOSettingsTableViewController)
final class BOSettingsTableViewController: UITableViewController, @MainActor BONewUserViewControllerDelegate, @MainActor BOViewControllerDelegate {
    @objc var boNewUserViewController: BONewUserViewController?
    @objc var users: NSMutableArray = []
    @objc var player: BOUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        let defaults = UserDefaults.standard
        let currentPlayer = defaults.integer(forKey: "currentPlayer")
        if currentPlayer == -1 {
            NSLog("This is a cold start")
            defaults.set(0, forKey: "noOfUsers")
            defaults.synchronize()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushPlay" {
            if let destination = segue.destination as? BOViewController,
               let selectedRowIndex = tableView.indexPathForSelectedRow {
                destination.users = users
                UserDefaults.standard.set(selectedRowIndex.row, forKey: "currentPlayer")
                UserDefaults.standard.synchronize()
            }
        }

        if segue.identifier == "linkModal",
           let navigationController = segue.destination as? UINavigationController,
           let newUserViewController = navigationController.topViewController as? BONewUserViewController {
            newUserViewController.delegate = self
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "BOUserCell"
        let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? BOUserCell)
            ?? BOUserCell(style: .value1, reuseIdentifier: reuseIdentifier)

        if let user = users[indexPath.row] as? BOUser {
            cell.userIdLabel?.text = user.userId
            cell.scoreLabel?.text = "\(user.score)"
        }
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        let visibleUsers = NSMutableArray(array: users)
        visibleUsers.removeObject(at: indexPath.row)
        users = visibleUsers

        let defaults = UserDefaults.standard
        let noOfUsers = defaults.integer(forKey: "noOfUsers")
        var currentPlayer = defaults.integer(forKey: "currentPlayer")
        var tempUsers = defaults.array(forKey: "users") ?? []
        var tempDiffs = defaults.array(forKey: "diffs") ?? []
        var tempScores = defaults.array(forKey: "scores") ?? []
        var tempColors = defaults.array(forKey: "colors") ?? []

        tempUsers.remove(at: indexPath.row)
        tempDiffs.remove(at: indexPath.row)
        tempScores.remove(at: indexPath.row)
        tempColors.remove(at: indexPath.row)

        defaults.set(tempUsers, forKey: "users")
        defaults.set(tempDiffs, forKey: "diffs")
        defaults.set(tempScores, forKey: "scores")
        defaults.set(tempColors, forKey: "colors")
        defaults.set(noOfUsers - 1, forKey: "noOfUsers")

        if currentPlayer == indexPath.row {
            currentPlayer = 0
        } else if currentPlayer > indexPath.row {
            currentPlayer -= 1
        }
        defaults.set(currentPlayer, forKey: "currentPlayer")
        defaults.synchronize()

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func boNewUserViewController(
        _ sender: BONewUserViewController,
        gotUserId uid: String,
        gotDifficulty diff: NSNumber,
        score: NSNumber,
        andGotBackgroundColor bkg: NSNumber
    ) {
        let newUser = BOUser(id: uid, difficulty: diff, score: score, backgroundColor: bkg)

        if newUser.userId.isEmpty {
            dismiss(animated: true)
            tableView.reloadData()
            return
        }

        let defaults = UserDefaults.standard
        let newUsers = (defaults.array(forKey: "users") as? [String] ?? []) + [uid]
        let newDiffs = (defaults.array(forKey: "diffs") as? [NSNumber] ?? []) + [diff]
        let newScores = (defaults.array(forKey: "scores") as? [NSNumber] ?? []) + [NSNumber(value: 0)]
        let newColors = (defaults.array(forKey: "colors") as? [NSNumber] ?? []) + [bkg]
        let noOfUsers = defaults.integer(forKey: "noOfUsers") + 1

        let appSettings: [String: Any] = [
            "currentPlayer": noOfUsers - 1,
            "noOfUsers": noOfUsers,
            "users": newUsers,
            "diffs": newDiffs,
            "scores": newScores,
            "colors": newColors
        ]

        defaults.register(defaults: appSettings)
        defaults.synchronize()

        let userArray = NSMutableArray()
        for index in 0 ..< newUsers.count {
            userArray.add(
                BOUser(
                    id: newUsers[index],
                    difficulty: newDiffs[index],
                    score: newScores[index],
                    backgroundColor: newColors[index]
                )
            )
        }
        users = userArray

        dismiss(animated: true)
        tableView.reloadData()
    }

    func newScore(_ sender: BOViewController, withScore myScore: Int32) {
        users = sender.users
        NSLog("Score=%d", myScore)
        dismiss(animated: true)
        tableView.reloadData()
    }
}
