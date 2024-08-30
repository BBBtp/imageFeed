
import UIKit
import Foundation
import ProgressHUD

final class AuthViewController : UIViewController{
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let storage = OAuth2TokenStorage()
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == ShowWebViewSegueIdentifier{
            guard let WebViewViewController = segue.destination as? WebViewViewController
            else{
                fatalError("Error prepare \(ShowWebViewSegueIdentifier) ❌")
            }
            WebViewViewController.delegate = self
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    private func configureBackButton(){
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward 1")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward 1")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black (iOS)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
}


extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self, let delegate = self.delegate else {
                    print("Error: AuthController not exists or delegate is nil")
                    return
                }
            
            UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let token):
                    self.storage.token = token
                    delegate.didAuthenticate(self)
                    print("Successful save token")
                case .failure(let error):
                    let alert = UIAlertController(title: "Упс..Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ок", style: .default)
                    alert.addAction(action)
                    vc.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
        }
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    
}
