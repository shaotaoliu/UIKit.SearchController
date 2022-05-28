import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var itemLabel: UILabel!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemLabel.text = item.name
    }
}
