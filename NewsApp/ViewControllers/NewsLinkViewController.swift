//
//  NewsLinkViewController.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 05.02.2023.
//

import UIKit
import WebKit

final class NewsLinkViewController: UIViewController, WKUIDelegate {
    
    private let link: String
    
    init(link: String) {
        self.link = link
        super.init(nibName: nil, bundle: nil)
    }
    
    private var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
