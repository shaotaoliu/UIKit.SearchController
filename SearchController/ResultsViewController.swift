import UIKit

class ResultsViewController: UITableViewController {

    @IBOutlet weak var resultLabel: UILabel!
    var navigation: UINavigationController?
    var filteredItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refresh(items: [Item]) {
        filteredItems = items
        tableView.reloadData()
        resultLabel.text = filteredItems.isEmpty ? "No items found" : "Items found: \(filteredItems.count)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = filteredItems[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        controller.item = filteredItems[indexPath.row]
        
        navigation?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
