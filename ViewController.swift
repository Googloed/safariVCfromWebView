//
//  ViewController.swift
//  persicon_test
//
//  Created by Ivan Prihodko on 10/12/2018.
//  Copyright © 2018 Ivan Prihodko. All rights reserved.
//
//  Этот код позволяет в нужный момент запускать из-под вкладки WebView, другой
//  браузер - SafariVC. Зачем это нужно? WebView удобен тем, что позволяет
//  показывать внутри мобильного приложения полностью кастомизированную
//  страницу. Без посторонних кнопок и панелей навигации, т.е. это идеальное
//  встраиваемое решение. Но зато SafariVC позволяет использовать запомненные
//  пароли и регистрацию Facebook, т.е. используя SafariVC мы можем избавить
//  пользователя от ещё одного ввода персональных данных. Ввести данные
//  (mail или телефон) несложно, но ведь нужно ещё пароль придумать, а потом
//  регистрацию желательно подтвердить - всё это неудобно, раздражает, а в итоге
//  ухудшает конверсию. Поэтому SafariVC - это тоже хорошо, но к сожалению он
//  запускает собственное окно, да к тому же имеет не отключаемый и не
//  кастомизируемый интерфейс. Поэтому родилась эта программа, которая
//  объединяет достоинства этих двух браузеров запускаемых внутри приложения -
//  WebView удобно и безшовно встраивается, а SafariVC даёт быструю регистрацию.
//
//  Программа является обработчиком ссылок специального вида для WebView.
//  При нажатии на такую ссылку, WebView запустит SafariVC. При нажатии на
//  обычную ссылку ничего такого не произойдёт - WebView будет работать в
//  обычном режиме.
//
//  Тесты показали, что нативный Safari делает регистрацию ещё проще и быстрее
//  чем SafariVC , поэтому программа позволяет запускать и его. Что в итоге
//  лучше использовать - будет решено в ходе экспериментов.

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
