import UIKit

class ViewController: UITableViewController {

    var searchController: UISearchController!
    var resultsController: ResultsViewController!
    
    var fruitItems = items.filter { $0.type == .fruit }
    var personItems = items.filter { $0.type == .person }
    var colorItems = items.filter { $0.type == .color }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsController = storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController
        resultsController.navigation = navigationController
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ItemType.all
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return personItems.count
        case 1:
            return fruitItems.count
        default:
            return colorItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = personItems[indexPath.row].name
        case 1:
            cell.textLabel?.text = fruitItems[indexPath.row].name
        default:
            cell.textLabel?.text = colorItems[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Person"
        case 1:
            return "Fruit"
        default:
            return "Color"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        
        switch indexPath.section {
        case 0:
            controller.item = personItems[indexPath.row]
        case 1:
            controller.item = fruitItems[indexPath.row]
        default:
            controller.item = colorItems[indexPath.row]
        }
        
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            reloadResultsController(items: items)
            return
        }
        
        let filteredItems = items.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        reloadResultsController(items: filteredItems)
    }
    
    private func reloadResultsController(items: [Item]) {
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        var filteredItems: [Item]
        
        switch selectedScope {
        case 0:
            filteredItems = items
        case 1:
            filteredItems = items.filter { $0.type == .person }
        case 2:
            filteredItems = items.filter { $0.type == .fruit }
        default:
            filteredItems = items.filter { $0.type == .color }
        }
        
        resultsController.refresh(items: filteredItems)
    }
}

extension ViewController: UISearchControllerDelegate {
    
    // Use these delegate functions for additional control over the search controller.
    
    func presentSearchController(_ searchController: UISearchController) {
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
    }
}

let items = [
    Item(name: "Kevin", type: .person),
    Item(name: "Chris", type: .person),
    Item(name: "Jason", type: .person),
    Item(name: "James", type: .person),
    Item(name: "John", type: .person),
    Item(name: "Jonathan", type: .person),
    Item(name: "Apple", type: .fruit),
    Item(name: "Pear", type: .fruit),
    Item(name: "Peach", type: .fruit),
    Item(name: "Blueberry", type: .fruit),
    Item(name: "Strawberry", type: .fruit),
    Item(name: "Blackberry", type: .fruit),
    Item(name: "Red", type: .color),
    Item(name: "Blue", type: .color),
    Item(name: "Green", type: .color),
    Item(name: "Purple", type: .color),
    Item(name: "Black", type: .color)
]

enum ItemType {
    case person
    case fruit
    case color
    
    static var all: [String] {
        ["All", "Person", "Fruit", "Color"]
    }
}

struct Item {
    let name: String
    let type: ItemType
}
