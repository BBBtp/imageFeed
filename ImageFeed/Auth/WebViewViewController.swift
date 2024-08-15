//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 12.08.2024.
//
import UIKit
import Foundation
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController{
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!
    
    
    
    //MARK: override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        webView.navigationDelegate = self
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            updateProgress()
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath:
                                #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    //MARK: private functions
    
    private func updateProgress(){
        progressView.progress=Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
        
    }
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.Token.unsplashAuthorizeURLString) else {
            print("Error get URL component!")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.Auth.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.Auth.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.Auth.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("Error get url")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) { //1
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)                
            decisionHandler(.cancel) //3
        } else {
            decisionHandler(.allow) //4
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            print("Successful get codeItem ")
            return codeItem.value
        } else {
            print("Error get codeItem")
            return nil
        }
    }
}
