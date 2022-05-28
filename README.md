# UIKit.SearchController

```Swift

class ViewController: UITableViewController {

    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: ResultViewController())
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["All", "Red", "Green", "Blue"]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension ViewController: UISearchBarDelegate {

    // Raised when the scope button is changed:
    func searchBar(_ searchBar: UISearchBar, 
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension ViewController: UISearchResultsUpdating {
    
    // Raised when the search text is changed in the search bar:
    func updateSearchResults(for searchController: UISearchController) {

        let searchText = searchController.searchBar.text 
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        …
    }
}

```

![image](https://user-images.githubusercontent.com/15805568/170815554-15613f7a-df9f-4ecd-8f2e-7a0b41ce6553.png)
