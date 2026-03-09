import UIKit

class GenericDemoViewController: BaseViewController {
    private let screenTitle: String

    init(screenTitle: String) {
        self.screenTitle = screenTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = screenTitle
    }
}
