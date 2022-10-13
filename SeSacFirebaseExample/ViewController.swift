//
//  ViewController.swift
//  SeSacFirebaseExample
//
//  Created by 신동희 on 2022/10/05.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Analytics.logEvent("share_image", parameters: [
            "name": "고래밥",
            "full_text": "안녕",
        ])

        Analytics.setDefaultEventParameters([
            "level_name": "Caverns01",
            "level_difficulty": 4
        ])
        
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    
    // 메서드 스위즐링
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController ViewWillAppear")
    }
    
    

    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        let numbers = [0]
        let _ = numbers[1]
    }
    
    
    
    // MARK: - IBAction
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        present(ProfileViewController(), animated: true)
    }
    
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
}





// MARK: - ViewControllers
class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
    }
    
    
    // 메서드 스위즐링
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController ViewWillAppear")
    }
}


class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
    
    
    // 메서드 스위즐링
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController ViewWillAppear")
    }
}








// MARK: - UIViewController 확장
// 스니펫으로 저장해서 활용하면 되는 코드
extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    
    // 최상위 뷰컨트롤러를 판단해주는 메서드
    // 탭바가 깔린 구조나 네비가 깔린 구조를 대응하기 위해 매개변수로 현재 뷰컨을 입력
    private func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewController(currentViewController: selectedViewController)
            
        }else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewController(currentViewController: visibleViewController)
            
        }else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
            
        }else {
            
            return currentViewController
        }
    }
}




// MARK: - 메서드 스위즐링
extension UIViewController {
    
    class func swizzleMethod() {
        
        let origin = #selector(viewWillAppear)
        let change = #selector(changeViewWillAppear)
        
        guard let originMethod = class_getInstanceMethod(UIViewController.self, origin), let changeMethod = class_getInstanceMethod(UIViewController.self, change) else {
            print("함수를 찾을 수 없거나 오류 발생")
            return
        }
        
        method_exchangeImplementations(originMethod, changeMethod)
    }
    
    
    @objc func changeViewWillAppear() {
        print("Change ViewWillAppear SUCCEED")
    }
}
