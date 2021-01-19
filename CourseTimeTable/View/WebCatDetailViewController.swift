//
//  WebCatDetailViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import UIKit

class WebCatDetailViewController: UIViewController {

    var webCat: WebCat?
    
    let closeBtn: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
        view.tintColor = .black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = closeBtn
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
