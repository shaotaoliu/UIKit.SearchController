import UIKit

class ViewController: UIViewController {

    private var transitioningDelegate1: TransitioningDelegate1?
    private var transitioningDelegate2: TransitioningDelegate2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func open1Tapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Popup1ViewController") as! Popup1ViewController
        transitioningDelegate1 = TransitioningDelegate1()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate1
        present(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController else {
            return
        }
        
        guard let controller = navController.viewControllers.first as? Popup2ViewController else {
            return
        }
        
        transitioningDelegate2 = TransitioningDelegate2(presenting: self, presented: controller, heightRatio: CGFloat(2.0 / 3.0))
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = transitioningDelegate2
    }
}

class TransitioningDelegate1: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController1(presentedViewController: presented, presenting: presenting)
    }
}

class TransitioningDelegate2: NSObject, UIViewControllerTransitioningDelegate {
    
    var presentedViewController: UIViewController
    var presentingViewController: UIViewController
    private let heightRatio: CGFloat
    
    init(presenting presentingViewController: UIViewController, presented presentedViewController: UIViewController, heightRatio: CGFloat) {
        self.presentingViewController = presentingViewController
        self.presentedViewController = presentedViewController
        self.heightRatio = heightRatio
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController2(presentedViewController: presented, presenting: presenting, heightRatio: heightRatio)
    }
}

class PresentationController1: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0,
                      y: containerView!.bounds.height * 2 / 3,
                      width: containerView!.bounds.width,
                      height: containerView!.bounds.height / 3)
    }
}

class PresentationController2: UIPresentationController {
    
    private var heightRatio: CGFloat
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, heightRatio: CGFloat) {
        self.heightRatio = heightRatio
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    private lazy var dimmingView: UIView = {
        let view = UIView(frame: containerView!.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        let height = containerView!.bounds.height * heightRatio
        let origin = CGPoint(x: 0, y: containerView!.bounds.height - height)
        let size = CGSize(width: containerView!.bounds.width, height: height)
        return CGRect(origin: origin, size: size)
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView,
              let coordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        coordinator.animate { [weak self] context in
            guard let self = self else {
                return
            }
            
            self.dimmingView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        coordinator.animate { [weak self] context in
            guard let self = self else {
                return
            }
            
            self.dimmingView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
