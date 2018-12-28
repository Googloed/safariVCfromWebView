//
//  ViewController.swift
//  persicon_test
//
//  Created by Ivan Prihodko on 10/12/2018.
//  Copyright © 2018 Ivan Prihodko. All rights reserved.
//

import UIKit // UIViewController, UIApplocation
import WebKit // WKNavigationDelegate, WKUIDelegate, WKWebView,
                // WKWebViewConfiguration, WKWindowFeatures, WKNavigationAction
import SafariServices //SFSafariViewController

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!

    override func loadView() {
        // WKWebView на весь view, с возможностью изменять навигацию
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Загрузка persicon в WKwebView и наделение правами на управление UI
        let url = URL(string: "https://persicon.ru/photolab_hd/phlb.html")!
        webView.uiDelegate = self
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Проверка url-адреса на параметр safnat для открытия нативного safari
        if (navigationAction.request.url!.absoluteString.range(of: "&safnat&") != nil) {
            UIApplication.shared.open(navigationAction.request.url!)
        // Проверка url-адреса на параметр safvc для открытия safari view content
        } else if (navigationAction.request.url!.absoluteString.range(of: "&safvc&") != nil) {
            let svc = SFSafariViewController(url: navigationAction.request.url!)
            self.present(svc, animated: true, completion: nil)
        // Оставаться в WKWebView во всех остальных случаях
        } else {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
